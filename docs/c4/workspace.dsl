/*
 * Gerado por fernando-moretes/platform como ponto de partida. ESTE arquivo e
 * seu: o rollout so cria se nao existir, nunca sobrescreve.
 *
 * Modelo C4 de app-aws-ai-reference-architectures. Renderize em https://c4.home.lab (Structurizr Lite)
 * ou cole em https://structurizr.com/dsl.
 */
workspace "app-aws-ai-reference-architectures" "Bilingual AWS AI reference architecture portfolio with Bedrock, RAG, MLOps, Terraform, Well-Architected notes and Vercel deployment." {

    configuration {
        scope softwaresystem
    }

    model {
        usuario = person "Usuário"
        sistema = softwareSystem "app-aws-ai-reference-architectures" "Bilingual AWS AI reference architecture portfolio with Bedrock, RAG, MLOps, Terraform, Well-Architected notes and Vercel deployment." {
            app = container "Aplicação" "Descreva o que roda aqui" "ci-generic.yml"
        }
        usuario -> sistema.app "Usa" "HTTPS"
    }

    views {
        systemContext sistema "contexto" {
            include *
            autoLayout lr
        }
        container sistema "containers" {
            include *
            autoLayout lr
        }
        styles {
            element "Person" {
                shape person
                background #08427b
                color #ffffff
            }
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "Container" {
                background #438dd5
                color #ffffff
            }
        }
    }
}
