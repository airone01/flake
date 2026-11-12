use strum::EnumString;

#[derive(EnumString, PartialEq, Debug, Clone)]
pub enum DerivType {
    #[strum(
        ascii_case_insensitive,
        serialize = "packages",
        serialize = "package",
        serialize = "p"
    )]
    Package,
    #[strum(
        ascii_case_insensitive,
        serialize = "nixosconfiguration",
        serialize = "nixosconfigurations",
        serialize = "nixos",
        serialize = "n"
    )]
    NixosConfiguration,
}

impl DerivType {
    pub fn as_str(&self) -> &'static str {
        match self {
            DerivType::Package => "packages",
            DerivType::NixosConfiguration => "nixosConfigurations",
        }
    }

    pub fn to_string(&self) -> String {
        String::from(self.as_str())
    }
}

mod tests {
    use crate::deriv_type::DerivType;
    use std::str::FromStr as _;

    #[test]
    fn test_as_str() {
        assert_eq!(DerivType::Package.as_str(), "packages");
        assert_eq!(
            DerivType::NixosConfiguration.as_str(),
            "nixosConfigurations"
        );
    }

    #[test]
    fn test_to_string() {
        assert_eq!(DerivType::Package.to_string(), "packages");
        assert_eq!(
            DerivType::NixosConfiguration.to_string(),
            "nixosConfigurations"
        );
    }

    #[test]
    fn test_from_str() {
        assert_eq!(DerivType::from_str("packages").unwrap(), DerivType::Package);
        assert_eq!(
            DerivType::from_str("n").unwrap(),
            DerivType::NixosConfiguration
        );
    }
}
