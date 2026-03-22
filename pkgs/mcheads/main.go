package main

import (
	"encoding/base64"
	"encoding/json"
	"fmt"
	"image"
	"image/png"
	"net/http"
	"strconv"
	"strings"
)

type Profile struct {
	Id         string `json:"id"`
	Properties []struct {
		Name  string `json:"name"`
		Value string `json:"value"`
	} `json:"properties"`
}

type TexturesData struct {
	Textures struct {
		Skin struct {
			Url string `json:"url"`
		} `json:"SKIN"`
	} `json:"textures"`
}

func getUUID(username string) (string, error) {
	resp, err := http.Get("https://api.mojang.com/users/profiles/minecraft/" + username)
	if err != nil || resp.StatusCode != 200 {
		return "", fmt.Errorf("user not found")
	}
	defer resp.Body.Close()

	var res struct{ Id string }
	json.NewDecoder(resp.Body).Decode(&res)
	return res.Id, nil
}

func getSkinURL(uuid string) (string, error) {
	resp, err := http.Get("https://sessionserver.mojang.com/session/minecraft/profile/" + uuid)
	if err != nil || resp.StatusCode != 200 {
		return "", fmt.Errorf("profile not found")
	}
	defer resp.Body.Close()

	var profile Profile
	json.NewDecoder(resp.Body).Decode(&profile)

	for _, prop := range profile.Properties {
		if prop.Name == "textures" {
			decoded, _ := base64.StdEncoding.DecodeString(prop.Value)
			var tex TexturesData
			json.Unmarshal(decoded, &tex)
			return tex.Textures.Skin.Url, nil
		}
	}
	return "", fmt.Errorf("no textures found")
}

// (nearest neighbor)
func scaleImage(src image.Image, targetSize int) image.Image {
	srcBounds := src.Bounds()
	srcWidth := srcBounds.Dx()
	srcHeight := srcBounds.Dy()

	dst := image.NewRGBA(image.Rect(0, 0, targetSize, targetSize))

	for y := 0; y < targetSize; y++ {
		for x := 0; x < targetSize; x++ {
			srcX := srcBounds.Min.X + (x * srcWidth / targetSize)
			srcY := srcBounds.Min.Y + (y * srcHeight / targetSize)
			dst.Set(x, y, src.At(srcX, srcY))
		}
	}
	return dst
}

func headHandler(w http.ResponseWriter, r *http.Request) {
	sizeStr := r.URL.Query().Get("size")
	targetSize := 8
	if sizeStr != "" {
		s, err := strconv.Atoi(sizeStr)
		// limit to 512
		if err == nil && s > 0 && s <= 512 {
			targetSize = s
		}
	}

	username := strings.TrimPrefix(r.URL.Path, "/avatar/")
	if username == "" {
		http.Error(w, "missing username", http.StatusBadRequest)
		return
	}

	uuid, err := getUUID(username)
	if err != nil {
		http.Error(w, "User not found", http.StatusNotFound)
		return
	}

	skinURL, err := getSkinURL(uuid)
	if err != nil {
		http.Error(w, "Skin not found", http.StatusNotFound)
		return
	}

	skinResp, err := http.Get(skinURL)
	if err != nil {
		http.Error(w, "Failed to download skin", http.StatusInternalServerError)
		return
	}
	defer skinResp.Body.Close()

	img, _, err := image.Decode(skinResp.Body)
	if err != nil {
		http.Error(w, "Failed to decode skin", http.StatusInternalServerError)
		return
	}

	faceRect := image.Rect(8, 8, 16, 16)
	subImager, ok := img.(interface {
		SubImage(r image.Rectangle) image.Image
	})
	if !ok {
		http.Error(w, "Image cropping failed", http.StatusInternalServerError)
		return
	}
	faceImg := subImager.SubImage(faceRect)

	// scale
	var finalImg image.Image = faceImg
	if targetSize != 8 {
		finalImg = scaleImage(faceImg, targetSize)
	}

	w.Header().Set("Content-Type", "image/png")
	w.Header().Set("Cache-Control", "public, max-age=86400")
	png.Encode(w, finalImg)
}

func main() {
	http.HandleFunc("/avatar/", headHandler)
	fmt.Println("Starting MC Head API on :8080...")
	http.ListenAndServe(":8080", nil)
}
