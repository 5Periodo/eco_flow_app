# Eco Flow App

Aplicativo Flutter para o projeto Eco Flow — front-end mobile e multiplataforma
destinado a gerenciar dados, interações e recursos do ecossistema Eco Flow.

## Visão geral

Este repositório contém a aplicação cliente Flutter usada pelo projeto Eco Flow.
Ele inclui a lógica de apresentação, integração com APIs (via `src`), e configurações
para Android, iOS e Web.

## Principais funcionalidades

- Interface responsiva para mobile e web
- Gerenciamento de usuários e autenticação
- Visualização de estatísticas e histórico
- Integração com serviços back-end (API REST/GraphQL)

## Pré-requisitos

- Flutter (estável) instalado — https://docs.flutter.dev/get-started/install
- Android SDK / Xcode (para builds nativos)
- Dispositivo/emulador ou navegador para testes

## Configuração rápida

1. Instale dependências:

```bash
flutter pub get
```

2. Rode a aplicação em um emulador/dispositivo conectado:

```bash
flutter run
```

3. Para executar no Chrome (Web):

```bash
flutter run -d chrome
```

4. Build para Android (APK):

```bash
flutter build apk --release
```

5. Build para iOS (macOS + Xcode):

```bash
flutter build ios --release
```

## Testes

Execute testes unitários e de widget:

```bash
flutter test
```

Para testes de integração/end-to-end, utilize o pacote apropriado e o comando
`flutter drive` conforme a configuração do projeto.

## Estrutura do projeto

- `lib/` - código fonte Flutter (UI, lógica e integração)
- `android/`, `ios/` - projetos nativos para cada plataforma
- `assets/` - imagens e recursos estáticos
- `test/` - casos de teste

## Contribuição

1. Faça um fork e crie uma branch com sua feature/bugfix.
2. Envie um pull request descrevendo a mudança e como testá-la.

## Contato

Para dúvidas ou ajuda, abra uma issue neste repositório.

---

README atualizado em Português com instruções de uso e build.
