# Programação para Dispositivos Móveis I — Aulas 10 e 11

## 📌 Visão Geral do Projeto
Este projeto reúne a implementação prática e avançada das **Aulas 10 e 11** da disciplina de Programação para Dispositivos Móveis I, com foco no consumo de APIs REST, manipulação defensiva de exceções, controle de estados de interface e navegação no padrão **Master-Detail (Lista-Detalhe)** em Flutter.

---

## 🎯 Conteúdos Abordados

### Aula 10: Consumo Avançado de APIs, Listas e Exceções
- **Mapeamento JSON defensivo:** Conversão de listas e objetos via `jsonDecode()` e `List.map()` para `NoticiaModel`.
- **Validação de Código de Status HTTP:** Checagem defensiva de `response.statusCode == 200`.
- **Tratamento Robusto de Exceções:** Blocos `try / catch / finally` gerenciando o ciclo de vida da requisição sem travar a interface.
- **Controle dos 4 Estados de Interface:**
  1. ⏳ **Carregando:** `CircularProgressIndicator` centralizado com feedback textual.
  2. ✅ **Sucesso:** `ListView.builder` com `Card` e `ListTile` renderizando apenas os itens visíveis.
  3. 📭 **Vazio:** Estado amigável para quando nenhuma notícia for encontrada.
  4. ❌ **Erro de Conexão:** Mensagem de erro e botão **"Tentar Novamente"** para recuperação rápida.

### Aula 11: Navegação com API — Fluxo Lista/Detalhe (Master-Detail)
- **Padrão Master-Detail:** A lista exibe o resumo dos dados e, ao tocar em um item, o usuário é direcionado para a tela completa.
- **Passagem de Objetos Tipados:** Envio direto da instância de `NoticiaModel` via construtor com `MaterialPageRoute`, evitando chamadas de rede redundantes.
- **Layout de Detalhes:** `SingleChildScrollView` com imagem, chip de identificação do autor, título em destaque, divisores e texto na íntegra.

---

## 🚀 Desafios Práticos Implementados

### Desafios da Aula 10
- **Básico — Filtro de Busca Local:** `TextField` no topo da lista com filtragem reativa por título em tempo real e botão de limpar busca.
- **Intermediário — Navegação para Detalhes:** Navegação direta ao clicar no item do card.
- **Avançado — Simulação de Erro de Conexão:** Botão interativo de Wi-Fi no topo da tela para simular queda de rede ou URL inválida, permitindo testar o estado de erro e o botão de recarga ("Tentar Novamente").

### Desafios da Aula 11
- **Básico — Hero Animation:** Transição fluida entre a lista principal e a tela de detalhes utilizando o widget `Hero(tag: 'noticia-img-${noticia.id}')`.
- **Intermediário — Ação de Favoritar:** Botão de coração interativo na tela de detalhes que altera o estado e retorna a informação para a tela anterior via `Navigator.pop(context, favorito)`.
- **Avançado — Comentários na Tela de Detalhes:** Segunda requisição à API REST (`/posts/{id}/comments`) carregando assincronamente os comentários associados à notícia com `FutureBuilder`.

---

## 📂 Estrutura de Arquivos

```
lib/
├── main.dart                          # Ponto de entrada com MaterialApp e tema teal
├── models/
│   ├── noticia_model.dart             # Modelo de dados da Notícia com factory fromJson
│   └── comentario_model.dart          # Modelo de dados dos Comentários da API
├── services/
│   └── noticia_service.dart           # Serviço HTTP com endpoints, try/catch e simulação de erro
└── screens/
    ├── feed_noticias_screen.dart      # Tela de Feed (Lista, busca, estados e navegação)
    └── detalhe_noticia_screen.dart    # Tela de Detalhes (Hero, favoritos e comentários)
test/
└── widget_test.dart                   # Testes unitários de modelos e testes de widget
```

---

## 🧪 Como Executar o Projeto

1. Certifique-se de ter o Flutter instalado e configurado:
   ```bash
   flutter --version
   ```

2. Obtenha as dependências:
   ```bash
   flutter pub get
   ```

3. Execute a análise estática:
   ```bash
   flutter analyze
   ```

4. Execute os testes automatizados:
   ```bash
   flutter test
   ```

5. Inicie o aplicativo no emulador ou dispositivo físico:
   ```bash
   flutter run
   ```
