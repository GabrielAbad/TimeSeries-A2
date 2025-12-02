## A2 de Séries Temporais

Este projeto realiza um estudo comparativo de diferentes modelos de previsão de séries temporais em um conjunto de dados contendo dados semanais de **`volume`**, **`inv`** e **`users`**. O objetivo principal é prever a variável **`volume`**.

-----

### Estrutura do Projeto

  * **`data_updated.csv`**: O conjunto de dados utilizado para o projeto.
  * **`RELATORIO.pdf`**: Versão em PDF do relatório final para o professor (gerado a partir de `main.typ`).
  * **`main.py`**: O script principal para executar as comparações de modelos.
  * **`ST_A2.ipynb`**: Um Jupyter notebook com análise exploratória de dados detalhada e avaliação de varios modelos.
  * **`TiDE.ipynb`**: Um Jupyter notebook que replica a funcionalidade de `main.py` em um ambiente interativo.

-----

### Primeiros Passos

#### Pré-requisitos

Você precisará ter o Python instalado, bem como as seguintes bibliotecas:

  * pandas
  * numpy
  * neuralforecast
  * pytorch-lightning
  * statsmodels
  * pmdarima
  * matplotlib
  * scikit-learn

Você pode instalar esses pacotes usando pip:

```bash
pip install pandas numpy neuralforecast pytorch-lightning statsmodels pmdarima matplotlib scikit-learn
```

#### Executando o Experimento Principal

O experimento principal pode ser executado a partir da linha de comando:

```bash
python main.py
```

Este script irá:

1.  Carregar o conjunto de dados `data_updated.csv`.
2.  Realizar uma busca em grade (*grid search*) para os modelos **TiDE** e **PatchTST**.
3.  Executar uma validação *walk-forward* para **TiDE**, **PatchTST** e um modelo simples **AR(1)**.
4.  Imprimir as métricas de avaliação para cada modelo.

-----

### Notebooks

O projeto também inclui dois Jupyter Notebooks para análises mais detalhadas:

  * **`ST_A2.ipynb`**: Este notebook fornece uma análise exploratória de dados do conjunto de dados e avalia varios modelos, incluindo Regressão Linear, ETS (Exponential Smoothing) e SARIMAX, além de vários modelos de *baseline* (linha de base).
  * **`TiDE.ipynb`**: Este notebook é uma versão interativa do script `main.py`.

-----

### Relatório em PDF para o professor

  * **Arquivo**: `RELATORIO.pdf` (gerado a partir de `main.typ`).
  * **Conteúdo**: discussão completa do trabalho, incluindo exploração inicial, baselines, diferenciação, ETS, SARIMAX e o comparativo final **TiDE vs PatchTST vs AR(1)** (com tabelas e gráficos de MAE/MASE por horizonte).
  * **Uso sugerido**: abra o PDF diretamente para leitura; se precisar ajustar ou recompilar, edite `main.typ` e gere o PDF com `typst compile main.typ`.

-----
