# Aula 8: Listas Dinâmicas & Arquitetura — PDM I (Flutter)

Projeto prático desenvolvido para a disciplina de **Programação para Dispositivos Móveis I** (Prof. Diego Menegassi) — Semestre 2026/2.

---

## 🎯 Visão Geral e Objetivos de Aprendizagem

- **Arquitetura Modular**: Estruturação profissional do projeto separando responsabilidades em `/models`, `/widgets` e `/screens`.
- **ListView.builder vs ListView Simples**: Otimização de desempenho com carregamento sob demanda (*Lazy Loading* / virtualização) de itens à medida que o usuário rola a lista, reduzindo drasticamente o consumo de memória RAM.
- **Componentização com Material Design 3**: Utilização de `Card`, `ListTile`, `CircleAvatar` e esquemas de cores modernos baseados em tokens.
- **Manipulação Reativa de Coleções (`setState`)**: Inclusão e remoção dinâmica de elementos em tempo de execução.
- **Gestos Avançados**: Remoção de itens por deslize lateral utilizando `Dismissible` (*Swipe to Dismiss*).
- **Navegação com Transferência de Dados**: Envio de objetos do modelo fortemente tipados via construtor entre telas com `Navigator.push`.
- **Commits Semânticos**: Histórico estruturado no Git seguindo as convenções de commits convencionais.

---

## 🏗️ Arquitetura do Projeto e Organização de Pastas

```
lib/
├── main.dart                          # Ponto de entrada (MaterialApp, tema indigo e rota inicial)
├── models/
│   └── produto.dart                   # Modelo fortemente tipado com atributos imutáveis (final)
├── widgets/
│   └── produto_card.dart              # Card modular reutilizável com ListTile e CircleAvatar
└── screens/
    ├── catalogo_screen.dart           # Tela de catálogo com ListView.builder e contador reativo
    └── detalhes_produto_screen.dart   # Tela de detalhes do produto (recebe Produto via construtor)
```

### Responsabilidades por Componente

| Diretório / Arquivo | Responsabilidade | Conceitos Aplicados |
| :--- | :--- | :--- |
| `lib/models/produto.dart` | Define a classe de dados do produto | Modelagem OO, imutabilidade (`final`), atributos requeridos |
| `lib/widgets/produto_card.dart` | Widget customizado de item | Reutilização de UI, `Card`, `ListTile`, `CircleAvatar` |
| `lib/screens/catalogo_screen.dart` | Gerenciamento de estado da lista | `ListView.builder`, `Scaffold`, `AppBar`, `Dismissible`, `FloatingActionButton` |
| `lib/screens/detalhes_produto_screen.dart` | Visualização detalhada do item | Navegação, passagem de parâmetros via construtor, UI rica MD3 |
| `lib/main.dart` | Ponto de entrada da aplicação | `MaterialApp`, `ThemeData`, `Material Design 3` |

---

## 🏆 Desafios de Laboratório Implementados

### 🟢 Nível 1 (Básico - Inclusão Dinâmica)
- Implementação de um `FloatingActionButton` na `CatalogoScreen`.
- Adiciona dinamicamente novos produtos à lista `_produtos` invocando o método `setState()`.
- O contador no `AppBar` (`Itens: ${_produtos.length}`) é atualizado reativamente em tempo real, acompanhado por um `SnackBar` informativo.

### 🟡 Nível 2 (Intermediário - Remoção por Gesto)
- Cada item do catálogo é envolvido pelo widget `Dismissible` com `key: Key(produto.id)`.
- Suporte a remoção ao deslizar o card (*Swipe to Dismiss* da direita para a esquerda).
- Plano de fundo estilizado em vermelho com ícone de exclusão e texto informativo.
- Exibição de `SnackBar` com ação `"Desfazer"` (*Undo*) para restaurar o item removido caso desejado.
- Exibição de estado visual amigável quando a lista estiver vazia.

### 🔴 Nível 3 (Avançado - Integração de Navegação)
- Criação da tela `DetalhesProdutoScreen` (`lib/screens/detalhes_produto_screen.dart`).
- Ao tocar no `ProdutoCard`, o app navega para a nova tela utilizando `Navigator.push`.
- A instância completa do `Produto` é transferida de forma segura via construtor.
- Interface rica com avatar ampliado, chips de categoria, identificador, preço formatado, descrição, botão de ação e botão de retorno.

---

## 🧪 Testes Automatizados

Foram implementados testes de widget completos cobrindo:
1. Renderização da lista inicial e contador do `AppBar`.
2. Inclusão dinâmica com `FloatingActionButton` e validação do incremento do contador (Nível 1).
3. Remoção de item por gesto via `Dismissible` (Nível 2).
4. Navegação para `DetalhesProdutoScreen` e retorno ao catálogo (Nível 3).

Para executar os testes:
```bash
flutter test
```

---

## 🚀 Como Executar o Projeto

1. **Instalar dependências**:
   ```bash
   flutter pub get
   ```

2. **Verificar análise estática**:
   ```bash
   flutter analyze
   ```

3. **Executar os testes**:
   ```bash
   flutter test
   ```

4. **Rodar a aplicação**:
   - No Google Chrome:
     ```bash
     flutter run -d chrome
     ```
   - No Windows Desktop:
     ```bash
     flutter run -d windows
     ```
