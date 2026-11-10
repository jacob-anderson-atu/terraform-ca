mock "tfconfig/v2" {
    module {
        source = "./tests/noncompliant/mock-tfconfig-v2.sentinel"
    }
}

mock "tfplan/v2" {
    module {
        source = "./tests/noncompliant/mock-tfplan-v2.sentinel"
    }
}

policy "infrastructure-security" {
    source = "./infrastructure-security.sentinel"
    enforcement_level = "hard-mandatory"
}

policy "supply-chain-security" {
    source = "./supply-chain-security.sentinel"
    enforcement_level = "hard-mandatory"
}

policy "digital-sovereignty" {
    source = "./digital-sovereignty.sentinel"
    enforcement_level = "hard-mandatory"
}
