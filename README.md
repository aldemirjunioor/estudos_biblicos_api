# App Bíblico com Estudos por IA 📖

Este é um aplicativo de estudo bíblico desenvolvido em Flutter. Ele permite aos usuários navegar pelos livros e capítulos da Bíblia, e, ao selecionar um versículo, gera um estudo aprofundado usando a API da OpenAI. Os usuários podem salvar esses estudos em sua conta pessoal e acessá-los a qualquer momento em uma biblioteca dedicada.

## Funcionalidades 🚀
- **Navegação Bíblica:** Explore todos os livros, capítulos e versículos.
- **Autenticação de Usuários:** Sistema de login e cadastro com Firebase Authentication.
- **Estudos com IA:** Geração de estudos de versículos com a API da OpenAI (GPT-3.5-turbo ou superior), incluindo:
  - Contexto Histórico
  - Aplicação Prática
  - Referências Cruzadas
- **Biblioteca de Estudos:** Salve seus estudos favoritos no Firestore e acesse-os em uma tela dedicada.
- **Visualizador de Links:** Abra referências externas (caso a IA forneça um link) dentro do aplicativo usando um WebView.

## Estrutura do Projeto 🛠️
O código está organizado na seguinte estrutura para garantir manutenibilidade e clareza:

- `lib/models`: Contém os modelos de dados (Book, Verse).
- `lib/pages`: Contém todas as telas da interface do usuário.
- `lib/services`: Contém a lógica de comunicação com as APIs (Bíblia, OpenAI) e com o Firebase.

---

## Configuração e Build do Projeto ⚙️
Siga as instruções abaixo para configurar e executar o projeto em sua máquina local.

### Pré-requisitos

- **Flutter SDK:** Certifique-se de ter o [Flutter](https://docs.flutter.dev/get-started/install) instalado.
- **Firebase CLI:** Você precisará da [Firebase CLI](https://firebase.google.com/docs/cli#install_the_cli) para conectar o projeto ao Firebase.

### 1. Clonar o Repositório ⚒️
```bash
git clone <URL_DO_SEU_REPOSITORIO>
cd myapp
```

### 2. Instalar as Dependências 🔄
Execute o seguinte comando para instalar todas as dependências listadas no `pubspec.yaml`:

```bash
flutter pub get
```

### 3. Configurar o Firebase 🔥
Este projeto usa o Firebase para autenticação e banco de dados.

- Crie um projeto no [console do Firebase](https://console.firebase.google.com/).
- Na raiz do projeto, execute o comando abaixo e siga as instruções para selecionar o projeto Firebase que você criou. Isso irá gerar automaticamente o arquivo `lib/firebase_options.dart`.

```bash
flutterfire configure
```

### 4. Configurar a Chave da API da OpenAI 🔑
A chave da API da OpenAI é necessária para a funcionalidade de geração de estudos.

- Na raiz do projeto, crie um arquivo chamado `.env`.
- Abra o arquivo `.env` e adicione a seguinte linha, substituindo `SUA_CHAVE_API_AQUI` pela sua chave real da OpenAI:

```
OPENAI_API_KEY=SUA_CHAVE_API_AQUI
```

**IMPORTANTE:** O arquivo `.env` contém informações sensíveis. Certifique-se de que ele esteja listado no seu arquivo `.gitignore` para evitar que sua chave secreta seja enviada para o GitHub. Se o `.gitignore` não tiver a linha abaixo, adicione-a:
```
# Secrets
.env
```
