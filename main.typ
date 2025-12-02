#set text(region: "BR", lang: "pt", size: 9pt)

#show link: set text(fill: blue)
#show link: underline

#show heading: set block(above: 1.2em, below: 1.0em)

#set math.mat(align: center)

#set list(indent: 1em, spacing: 0.6em)
#set line(length: 100%, stroke: 1pt+black)
#set page(columns: 2, margin: 45pt, numbering: "1", number-align: bottom + right)
#set par(justify: true)
#set heading(numbering: "1.1  ")

#let line_gray() = line(length: 100%, stroke: (paint: gray, thickness: 1pt, dash: "dashed"))

#let overset(a, b) = {
 math.attach(math.limits(a), t: b)
}
#let overtil(a) = {
  math.attach(math.limits(a), t: $tilde$)
}

#set table(stroke: none)

#let toprule = table.hline(stroke: 0.08em)
#let bottomrule = toprule

#let midrule = table.hline(stroke: 0.05em)

#place(top+center, scope: "parent", float: true, align(center)[
  #text(24pt, weight: "bold")[
    Considerações sobre a Modelagem de \
    Séries Temporais
  ]
  #set text(12pt)
  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 1em,
    row-gutter: 0.5em,
    align(center)[
      Anderson Falcão#super[1] \
    ],
    align(center)[
      Antonio Brych#super[1] \
    ],
    align(center)[
      Gabriel Abad#super[1] \
    ],
    align(center)[
      Pedro Tokar#super[1] \
    ],
    align(center)[
      Tomás Lira#super[1] \
    ],
    align(center)[
      Vitor Moreira#super[1] \
    ],
  )
  #text(10pt, weight: "regular", fill: luma(100))[
    #super[1]Escola de Matemática Aplicada — FGV EMAp
  ]
  #line(length: 100%, stroke: 1.5pt)
  #v(2em)
])


= Introdução <introdução>
Este trabalho visa modelar e prever a variável 'volume' contida no conjunto de dados fornecido, usando as variáveis auxiliares 'users' e 'inv'. A série temporal abrange o período de 2022-10-31 a 2025-10-27 com intervalos semanais, totalizando 150 semanas de observação.

== Exploração inicial do dados <exploração-inicial-do-dados>

#figure(
  align(
    center,
  )[#table(
      columns: 4,
      align: (left, left, right,),
      toprule,
      table.header([], [#strong[volume]], [#strong[inv]], [#strong[users]]),
      midrule, 
      [mean], [4.820382], [0.712956], [6.576834],
      [std],  [5.162304], [0.889207], [6.596819],
      [min],  [0.140000], [0.000240], [0.401000],
      [25%],  [0.660000], [0.076311], [1.351000],
      [50%],  [3.250000], [0.464850], [3.847000],
      [75%],  [7.550000], [0.859225], [9.768000],
      [max],  [24.52000], [5.623875], [29.33200],
      bottomrule
    )],
    caption: [Descrição Estatística dos Dados], kind: table,
) <tab:desc_stats_volume>

#figure(image("imgs/dinamica_temporal.png", width: 80%), caption: [
  Line plot da dinâmica temporal das variáveis
])
<fig:placeholder>

O lineplot das variáveis em relação ao tempo já começa mostrando padrões interessantes, principalmente para as novas covariáveis. Observamos que o comportamento delas é semelhante durante 2023 e durante os três primeiros trimestes de 2024, apresentando valor baixo e aparentemente constante em 2023 e tendo um aumento em 2024. Apesar dos valores serem diferentes, os momentos de alta das séries parecem sempre ocorrer no mesmo período.

Além disso, o aumento delas também segue o aumento da série volume, o que já pode ser visto como motivação para se incluir as covariáveis na modelagem. Essas observações empíricas podem ser confirmadas quando analisamos a correlação entre as variáveis:

#figure(/*  */image("imgs/correlacoes.png", width: 80%), caption: [
  Correlações entre as variáveis
])
<fig:placeholder>

Seguindo a mesma motivação da entrega anterior (heterocedastidade), podemos aplicar uma transformação logarítmica nas variáveis:

#figure(image("imgs/dinamica_temporal_log.png", width: 80%), caption: [
  Line plot da dinâmica temporal das variáveis transformadas com log
])
<fig:placeholder>

#figure(image("imgs/correlacoes_log.png", width: 80%), caption: [
  Correlações entre as variáveis transformadas com log
])
<fig:placeholder>

A correlação linear entre as covariáveis e "volume" aumenta se aplicarmos uma transformação logarítmica nelas, isso pode ser interessante para construir os modelos para ter melhores resultados. Vale observar, porém, que a correlação entre as variáveis `inv` e `users` é alta, o que pode ser prejudicial para alguns modelos, já que as informações de cada coluna serão quase colineares.

= Modelos baseline

Pela própria natureza dos modelos baseline utilizados, nenhuma de suas formulações aceitam covariáveis. À luz disso, esperamos um comportamento similar ao que foi visto anteriormente. 

Continuamos adotando o valor unitário para o passo mas desta vez com horizonte igual a 4, isto é, com nosso modelo prevendo 4 semanas consecutivas, sustentado por uma janela de contexto de 52 semanas.

O horizonte de previsão foi ampliado em relação ao trabalho anterior para evitar a superestimação sistemática do desempenho do modelo Naive, uma distorção que ocorria ao utilizar apenas um passo à frente ($h=1$).

Realizamos um grid search para determinar o melhor hiperparâmetro para o modelo #strong[Seasonal Naive]:

#figure(image("imgs/grid_search.png", width: 100%), caption: [
  Grid-Search para modelo Seasonal Naive
])

O gráfico acima sugere que o melhor modelo para esses dados é o Naive simples (olhar apenas para o valor imediatamente anterior, $s=1$), pois tentar buscar padrões sazonais mais longos apenas aumentou o erro.


#figure(align(center)[
    #table(
        columns: 6, 
        align: (left, right, right, right, right, right,), 
        toprule,
        table.header(
          [#strong[Modelo];], [#strong[R²];], [#strong[MAE];], [#strong[MSE];], [#strong[RMSE];], [#strong[Média Resíduos (ȳ)];],
        ), 
        midrule,
        [Naive], [0.849886], [1.330956], [3.526443], [1.877883], [0.431838],
        [Seasonal Naive], [0.849886], [1.330956], [3.526443], [1.877883], [0.431838],
        [Mean], [-0.603601], [4.651042], [37.671449], [6.137707], [4.648174],
        [Drift], [0.853469], [1.327347], [3.442281], [1.855339], [0.299659],
        bottomrule
      )
    ], 
    caption: [Métricas de desempenho dos modelos baseline com Seasonal Naive s = 1.], 
    kind: table,
  ) <tab:metricas1>

Considerando  as métricas de resumo acima, observamos que os modelos Drift e Seasonal Naive apresentaram os resultados mais aceitáveis, sendo o primeiro superior por exibir menor RMSE e maior $R^2$

  
#figure(image("imgs/output.png", width: 100%), caption: [
  Avaliação usando o ACF para cada modelo
])



Tanto o Naive quanto o Seasonal Naive apresentaram bons resultados, com resíduos sem padrões fortes e contidos na margem de segurança, sendo que o Seasonal acabou se comportando de forma idêntica ao Naive pelo fato de seu ciclo ótimo ter sido igual a 1. 

Por outro lado, o modelo Mean mostrou-se um baseline ruim ao exibir forte autocorrelação e barras grandes que evidenciam sua falha em explicar a dinâmica da série, enquanto o Drift se confirmou como a melhor opção, gerando resíduos comportados.

#figure(image("imgs/residuos_baseline.png", width: 100%), caption: [
  Comparação dos histogramas de resíduos para cada modelo
])

A análise dos histogramas de resíduos mostram que o Naive e o Seasonal Naive apresentaram comportamentos muito semelhantes e positivos, com distribuições razoavelmente simétricas e centradas, indicando estabilidade e baixo viés. 

O modelo Mean exibiu forte assimetria com resíduos concentrados à direita do zero, demonstrando que ele subestima os valores reais. Por fim, o Drift destacou-se novamente como a melhor opção, apresentando uma distribuição mais concentrada em zero e com menor dispersão que os demais.

== Conclusão
Diferentemente do restante do trabalho, onde adotamos amplamente um horizonte curto (h=1) e o modelo Naive predominava, a ampliação do horizonte nesta etapa revelou um comportamento distinto. Neste cenário de longo prazo, o Drift apresentou desempenho superior, pois é o único baseline capaz de projetar a tendência da série, ao contrário do Naive, que apenas replica o último valor observado e perde precisão conforme o horizonte cresce.


= Diferenciação

A análise de diferenciação é uma etapa crítica na modelagem de séries temporais, especialmente ao utilizar modelos da família ARIMA. A principal utilidade deste processo é transformar uma série temporal não estacionária em estacionária.

Uma série é considerada estacionária quando suas propriedades estatísticas: como média, variância e autocorrelação permanecem constantes ao longo do tempo. Isso é fundamental porque:
1.  *Estabilidade Preditiva:* Modelos estatísticos clássicos assumem que o comportamento passado (média e variância) se repetirá no futuro. Tendências e sazonalidades violam essa premissa.
2.  *Remoção de Tendência e Sazonalidade:* A diferenciação remove componentes determinísticos (como o crescimento contínuo de vendas) e ciclos repetitivos (padrões anuais), isolando o componente estocástico (ruído e sinal de curto prazo) que o modelo deve prever.
3.  *Evitar Correlações Espúrias:* Trabalhar com dados em nível (sem diferenciar) pode levar a regressões espúrias, onde duas variáveis parecem correlacionadas apenas porque ambas crescem ao longo do tempo, sem haver causalidade real.

== Metodologia

Para esta análise, aplicou-se inicialmente uma *transformação logarítmica* nas variáveis (`volume`, `inv`, `users`) para estabilizar a variância (heterocedasticidade) e linearizar relações exponenciais.

Posteriormente, a estacionariedade foi verificada utilizando o teste *Augmented Dickey-Fuller (ADF)*.
- *Hipótese Nula ($H_0$):* A série possui uma raiz unitária (é não estacionária).
- *Hipótese Alternativa ($H_1$):* A série é estacionária.
- *Critério:* Rejeita-se $H_0$ se o p-valor for menor que 5%.

== Resultados
Abaixo estão os resultados obtidos para a variável alvo (`log_volume`) em diferentes ordens de diferenciação:

#figure(image("imgs/img1_diff.png", width: 86%), caption: [
  Line plot com as diferentes diferenciações avaliadas
])
<fig:placeholder>

#figure(image("imgs/img2_diff.png", width: 80%), caption: [
  Matriz de correlação entre as variáveis com diferenciação de primeira ordem
])
<fig:placeholder>

*Série em Nível (Log Volume)*
- Estatística ADF: -1.1603
- P-valor: 0.6904
- Conclusão: A série original não é estacionária. O p-valor alto indica a presença clara de uma tendência ou raiz unitária, confirmando a necessidade de diferenciação.

*Primeira Diferença no Log Volume ($Delta y_t = y_t - y_(t-1)$)*
- Estatística ADF: -5.9177
- P-valor: 0.0000
- Conclusão: A série tornou-se estacionária com alta significância estatística. A primeira diferença foi eficaz em remover a tendência linear dos dados.
- Análise Visual (ACF/PACF): Os gráficos de autocorrelação mostram um decaimento rápido, característico de séries estacionárias, embora ainda possam existir correlações sazonais remanescentes.

*Diferença Sazonal ($Delta y_t = y_t - y_(t-52)$)*
- Estatística ADF: -2.1894
- P-valor: 0.2101
- Conclusão: A diferenciação apenas sazonal (lag 52, correspondente a um ano em dados semanais) não foi suficiente para tornar a série estacionária. Isso sugere que, embora haja sazonalidade, a tendência (nível da série) ainda domina a estrutura dos dados.

*Diferença Combinada (1ª Ordem + Sazonal)*
- Estatística ADF: -12.0638
- P-valor: 0.0000
- Conclusão: A aplicação de ambas as diferenças tornou a série estacionária. No entanto, é necessário cautela: a sobrediferenciação pode introduzir ruído desnecessário e correlações negativas artificiais.

Foi analisada a matriz de correlação entre a variável alvo (`volume`) e as covariáveis (`inv`, `users`) após a transformação logarítmica e a primeira diferença.

#figure(align(center)[
  #table(
      columns: 4, align: (left, right, right, right, right, right,), 
      toprule,
      table.header(
        [#strong[X];], [#strong[Y];], [#strong[Correlação (Log)];], [#strong[Correlação (1ª Diferença)];]
      ), 
      midrule,
      [Volume], [Users], [0.67], [0.67],
      [Volume], [Inv], [0.31], [0.30],
      [Inv], [Users], [0.80], [0.54],
      bottomrule
    )], 
    caption: [], kind: table,
) <tab:tabela_correlacao_diff>

*Observações:*
1.  *Robustez da Relação Volume-Users:* A correlação entre `volume` e `users` manteve-se forte (~0.67) mesmo após a diferenciação. Isso indica que o crescimento de usuários está genuinamente ligado ao crescimento do volume, e não é apenas uma tendência coincidente.
2.  *Multicolinearidade:* A correlação entre as covariáveis (`inv` e `users`) caiu de 0.80 (nível) para 0.54 (diferença). Isso é positivo para a modelagem, pois reduz (embora não elimine) o risco de multicolinearidade que poderia inflar a variância dos coeficientes no modelo SARIMAX.

#figure(image("imgs/img4_diff.png", width: 100%), caption: [
  ACF / PACF dos 3 tipos de diferenciação testados.
])
<fig:placeholder>

== Conclusão e aprendizados

A análise indica que o modelo preditivo deve operar sobre a série transformada.
- Para modelos ARIMA/SARIMA, recomenda-se utilizar $d=1$ (uma diferenciação de primeira ordem) para tratar a tendência.
- O uso de $D=1$ (diferenciação sazonal) deve ser validado via critério de informação (AIC), pois o teste ADF da primeira diferença já indicou estacionariedade suficiente, e a diferenciação dupla pode ser excessiva dado o tamanho da amostra (~3 ciclos anuais).
- A variável `users` demonstrou ser um preditor robusto e deve ser priorizada como variável exógena no modelo.

= Regressão Linear Simples

Antes de partir para a análise e entendimento de modelos pensados para séries temporais, é um exercício interessante estudar o modelo estatístico de regressão linear padrão, sem a adição de terrmos autoregressivos ou quaisquer outros que levem a modelagem temporal em consideração. Isso é útil para comparação posterior e para entender o quanto a estrutura temporal ajuda ou não na predição da série que estamos trabalhando.

#figure(align(center)[
  #table(
    columns: 4, align: (left, right, right, right),
    toprule,
    table.header(
      [], [#strong[MAE (h=1)]], [#strong[RMSE (h=1)]], [#strong[MASE (h=1)]]
    ),
    midrule,
    [Regressão completa], [5.0444], [6.5153], [1.4160],
    [Regressão com users], [5.5627], [6.7705], [1.5697],
    [Regressão com covariáveis log], [4.6223], [6.0683], [1.2964],
    [Regressão com log users], [4.9678], [6.0963], [1.4004],
    bottomrule
    )
],
caption: [Métricas de desempenho dos modelos sem modelagem temporal]
)
Obsevamos um desempenho consideravelmente pior dos modelos tradicionais do que os modelos baseline feitos para séries temporais. Essa piora indica que a modelagem temporal é essencial para predizer a série de interesse.

= Modelos de Suavização Exponencial

Os modelos de suavização exponencial são uma classe de modelos temporais que não requerem estacionariedade. Nesta análise, foram testadas duas variantes ETS na série _log_volume_ para estabilizar a variância (heterocedasticidade), conforme a metodologia:

1. Holt (Trend Only): Modela o nível e a tendência (aditiva e amortecida)
2. Holt-Winters (Seasonal): Adiciona o componente sazonal com período de 52 semanas.

== Avaliação do desempenho

#figure(align(center)[
  #table(
      columns: (1.5fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr),
      align: (left, center, center, center, center, center, center),
      toprule,
      table.header(
        [#strong[Modelo]],
        [#strong[$"AIC"$]],
        [#strong[BIC]],
        [#strong[MASE (h=1)]],
        [#strong[MASE (h=2)]],
        [#strong[MASE (h=3)]],
        [#strong[MASE (h=4)]],
        [#strong[RMSE (h=4)]],
      ), 
      midrule,
      [Holt], [-243.0], [-230.9], [0.35], [0.49], [0.56], [0.54], [2.49],
      [Holt Winters], 	[-79.5], 	[-89.6], 	[0.37], 	[0.57], 	[0.74], 	[0.86], 	[3.98]
    )], 
    caption: [Métricas de desempenho (walk-forward) dos modelos ETS aplicados à série _log_volume_],
    kind: table,
) <tab:tabela_ets>

1.  O modelo Holt (Trend Only) obteve as melhores métricas internas (AICc​ e BIC) e o melhor desempenho na previsão walk-forward. Este modelo alcançou um MASE (h=1) de 0.35, indicando que o erro médio de previsão é significativamente menor do que o erro do modelo Seasonal Naive.

2. O modelo Holt-Winters, que tenta capturar a sazonalidade de 52 semanas, teve um desempenho pior nas métricas internas e externas (RMSE h=4 de 3.98).

= Modelos SARIMAX

O modelo SARIMAX foi aplicado à série _log_volume_ com a diferenciação de primeira ordem (d=1) já definida para tratar a tendência. A ordem do modelo sazonal (D=0) foi mantida em zero, reforçando a conclusão da seção 4.3 de que a sazonalidade não é forte o suficiente para justificar a diferenciação sazonal.

== Tratamento da Multicolinearidade

Uma etapa importante foi o tratamento da multicolinearidade entre as covariáveis _log_users_ e _log_inv_:

1. Correlação Original: A correlação entre inv e users na escala original era alta (aproximadamente 0.83).
2. Correlação na Série Diferenciada: Após a transformação logarítmica e a diferenciação de primeira ordem (d=1), a correlação foi reduzida para 0.54.

Apesar da redução, a inclusão de ambas covariáveis no SARIMAX resultou em um desempenho subótimo devido à redundância informacional e ao aumento da variância dos coeficientes (multicolinearidade).

#figure(align(center)[
  #table(
      columns: (1.5fr,1fr,1fr,1fr),
      align: (left, center, center, center),
      toprule,
      table.header(
        [#strong[Modelo]],
        [#strong[MASE (h=1)]],
        [#strong[MASE (h=4)]],
        [#strong[RMSE (h=4)]],
      ), 
      midrule,
      [ETS (Holt Trend)], [0.3528], [0.5413], [2.4907],
      [Sarimax (Exog)], [0.2720], [0.4375], [2.0069],
    )], 
    caption: [Comparativo de desempenho entre o melhor ETS e o modelo SARIMAX final.],
    kind: table,
) <tab:tabela_sarimax>

/*#figure(align(center)[
  #table(
    columns: 4, align: (left, right, right, right),
    toprule,
    table.header(
      [], [#strong[MASE (h=1)]], [#strong[MASE (h=4)]], [#strong[RMSE (h=4)]]
    ),
    midrule,
    [Regressão completa], [1.4160], [1.6985], [7.7232],
    [Regressão com users], [1.5697], [1.8364], [7.9032],
    [Regressão com covariáveis log], [1.2964], [1.5466], [7.2055],
    [Regressão com log users], [1.4004], [1.6403], [7.1818],
    bottomrule
    )
],
caption: [Métricas de desempenho dos modelos sem modelagem temporal]
)

MAE (h=1)	RMSE (h=1)	MASE (h=1)
[Regressão completa], [5.0444], [6.5153], [1.4160],
[Regressão com users], [5.5627], [6.7705], [1.5697],
[Regressãocom covariáveis log], [4.6223], [6.0683], [1.2964]
[Regressão com log users], [4.9678], [6.0963], [1.4004]
*/