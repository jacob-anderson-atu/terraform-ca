policy "infrastructure-security" {
    source = "./infrastructure-security.sentinel"
    enforcement_level = "hard-mandatory"
}

policy "supply-chain-security" {
    source = "./supply-chain-security.sentinel"
    enforcement_level = "hard-mandatory"
}

policy "digital-sovereignty" {
    source "./digital-sovereignty.sentinel"`
    enforcement_level = "hard-mandatory"
}

mock "tfplan/v2" {
    module{
        source = "./tests/mock-tfplan-v2.sentinel"
    }
}