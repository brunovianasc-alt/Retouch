# Retouch

Protótipo iOS original para edição de fotos. Ele usa SwiftUI, PhotosUI e Core Image e não contém código, recursos, modelos ou marca do aplicativo analisado.

## Recursos atuais

- importar uma imagem da biblioteca;
- aplicar filtro (Original, Mono, Vívido e Dramático);
- ajustar a intensidade do filtro;
- exportar a imagem editada para a biblioteca de Fotos.

## Requisitos

- iOS 17 ou superior.
- O projeto Xcode é gerado a partir de `project.yml` com o [XcodeGen](https://github.com/yonaskolb/XcodeGen).

## Gerar o IPA pelo Windows (GitHub Actions)

1. Crie um repositório no GitHub (público, para ter minutos de macOS grátis).
2. Envie **todo o conteúdo da pasta `teste`**: `project.yml`, `.gitignore`, `.github/workflows/build-ipa.yml` e a pasta `Retouch/`.
3. Na aba **Actions**, abra o workflow **Build IPA** e clique em **Run workflow** (ele também roda a cada push na `main`).
4. Quando terminar, baixe o artefato **Retouch-unsigned-ipa** na página da execução.
5. O IPA vem **sem assinatura**. Para instalar no iPhone, assine e instale com o **Sideloadly** ou o **AltStore** usando seu Apple ID.

## Abrir no Mac (Xcode)

```bash
brew install xcodegen
xcodegen generate
open Retouch.xcodeproj
```

Em *Signing & Capabilities*, escolha o seu time e troque `com.seudominio.retouch` por um identificador próprio.
