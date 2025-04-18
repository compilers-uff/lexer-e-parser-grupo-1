[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/4nHL7_6-)
[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-2e0aaae1b6195c2367325f4f02e2d04e9abb55f0b24a779b69b11b9e10269abc.svg)](https://classroom.github.com/online_ide?assignment_repo_id=18897865&assignment_repo_type=AssignmentRepo)

# CS 164: Programming Assignment 1

[PA1 Specification]: https://drive.google.com/open?id=1oYcJ5iv7Wt8oZNS1bEfswAklbMxDtwqB
[ChocoPy Specification]: https://drive.google.com/file/d/1mrgrUFHMdcqhBYzXHG24VcIiSrymR6wt

Note: Users running Windows should replace the colon (`:`) with a semicolon (`;`) in the classpath argument for all command listed below.

## Getting started

Run the following command to generate and compile your parser, and then run all the provided tests:

    mvn clean package

    java -cp "chocopy-ref.jar:target/assignment.jar" chocopy.ChocoPy --pass=s --test --dir src/test/data/pa1/sample/

In the starter code, only one test should pass. Your objective is to build a parser that passes all the provided tests and meets the assignment specifications.

To manually observe the output of your parser when run on a given input ChocoPy program, run the following command (replace the last argument to change the input file):

    java -cp "chocopy-ref.jar:target/assignment.jar" chocopy.ChocoPy --pass=s src/test/data/pa1/sample/expr_plus.py

You can check the output produced by the staff-provided reference implementation on the same input file, as follows:

    java -cp "chocopy-ref.jar:target/assignment.jar" chocopy.ChocoPy --pass=r src/test/data/pa1/sample/expr_plus.py

Try this with another input file as well, such as `src/test/data/pa1/sample/coverage.py`, to see what happens when the results disagree.

## Assignment specifications

See the [PA1 specification][] on the course
website for a detailed specification of the assignment.

Refer to the [ChocoPy Specification][] on the CS164 web site
for the specification of the ChocoPy language.

## Receiving updates to this repository

Add the `upstream` repository remotes (you only need to do this once in your local clone):

    git remote add upstream https://github.com/cs164berkeley/pa1-chocopy-parser.git

To sync with updates upstream:

    git pull upstream master

## Sessão 6.4 do Enunciado: Considerações de Implementação

### Membros do Grupo

- Lucca Sabbatini;
- Renato Montini;
- Sérgio Ricardo.

### Agradecimentos

Agradecimentos aos colegas de turma Isadora Verbicário, João Pedro Mateus e João Guilherme por terem ajudado com a implementação da gramática do ChocoPy.
Agradecimentos à Rohan Padhye, Koushik Sen e Paul Hilfinger da Universidade de Berkley por escreverem um ótimo manual e referência de linguagem para o ChocoPy.
Agradecimentos à Scott Hudson e ao JFlex Team por terem escrito documentações precisas e abrangentes para as ferramentas CUP e JFlex, respectivamente.

### Tempo de Desenvolvimento

Fora o tempo investido apenas na contextualicação teórica e nos estudos sobre a linguagem ChocoPy prévios ao início do desenvolvimento, estima-se que o tempo total de desenvolvimento tenha sido de aproximadamente 42 horas.

Esse tempo foi calculado pensando que o primeiro commit ao repositório foi no dia 05/04/2025, que dista de 12 dias da data na qual este documento está sendo atualizado pela última vez antes da entrega do trabalho. Foi estimado um tempo investido à implementação do trabalho de 10 horas por semana útil, totalizando assim algo perto de 20 horas de trabalho.

### Questões

#### 1. Que estratégia você usou para emitir tokens INDENT e DEDENT corretamente? Mencione o nome do arquivo e o(s) número(s) da(s) linha(s) para a parte principal da sua solução.

Separamos o Lexer em dois estados principais (além de um terceiro auxiliar para processamento de strings). O estado YYINITIAL ficou responsável por analisar linhas lógicas inteiras (destarcando comentários e linhas vazias), se preocupando somente com a emissão de tokens de indentação (INDENT e DEDENT). Já o estado SCANLINE ficou responsável por analisar os lexemas dentro de cada linha lógica, descartando qualquer indentação no começo da linha.

Foram definidos duas estruturas de dados para auxiliar no controle de indentação dos programas: uma pilha `indentStrack` (do tipo `Stack<Integer>`) e uma fila `indentBuffer` (do tipo `Queue<Symbol>`). A pilha é usada para controlar o nível de indentação atual, adicionando um novo nível quando um token INDENT é emitido e removendo o nível quando um token DEDENT é emitido. A fila é usada para armazenar os tokens de indentação que foram emitidos, permitindo que eles sejam processados posteriormente. Isso é necessário porque, mesmo que em alguns casos seja necessário emitir mais de um DEDENT de uma só vez, por exemplo, só é possível retornar um token para o parser por vez. Ao definir um buffer de tokens, conseguimos emitir quantos tokens forem necessários para o parser, basta adicionarmos à fila os tokens que estaríamos retornando ao parser e, ao início do processamento de cada linha, checamos se o buffer se encontra vazio. Se o buffer estiver vazio, a linha que foi consumida pelo automato é processada normalmente. Se o buffer não estiver vazio, a linha que foi consumida pelo automato é preservada para a próxima iteração (`yypushback(yylength())`) e o primeiro token do buffer é retornado ao parser.

##### Estruturas de dados auxiliares (Linhas 41-43):

https://github.com/compilers-uff/lexer-e-parser-grupo-1/blob/111fd2815e6dbf340186484cf62500585317580e/src/main/jflex/chocopy/pa1/ChocoPy.jflex#L41-L43

##### Lógica de tratamento de indentação (Linhas 177-204):

https://github.com/compilers-uff/lexer-e-parser-grupo-1/blob/111fd2815e6dbf340186484cf62500585317580e/src/main/jflex/chocopy/pa1/ChocoPy.jflex#L177-L204

#### 2. Como sua solução ao item 1. se relaciona ao descrito na seção 3.1 do manual de referência de ChocoPy? (Arquivo chocopy_language_reference.pdf.)

Os conceitos de Linha Física, Linha Lógica, Comentários e Linhas Vazias foram utilizados para distringuir quais linhas do programa deveriam ser levadas em consideração no tratamento de indentação. A sessão 3.1.5 Indentation foi essencial para o desenvolvimento do mecanismo, pois ela explicita exatamente o que deve ser feito para garantir a corretude dos níveis de indentação. Nosso algoritmo é apenas a tradução do comportamento descrito em linguagem natural na sessão do documento para linguagem de programação no arquivo JFlex.

#### 3. Qual foi a característica mais difícil da linguagem (não incluindo identação) neste projeto? Por que foi um desafio? Mencione o nome do arquivo e o(s) número(s) da(s) linha(s) para a parte principal de a sua solução.

Tivemos dois outros desafios além da identação.
O primeiro foi na definição dos símbolos terminais. Inicialmente não percebemos que a ordem da declaração deles era importante e por isso estávamos tendo problemas para compilar o código e sempre recebíamos avisos que alguns símbolos não eram alcançados nunca. Utilizamos o Github Copilot para nos explicar o erro e ele nos informou que a ordem importava, então alteramos a ordem da nossa declaração para que todos os símbolos pudessem ser alcançados. Arquivo ChocoPy.jflex, a partir da linha 210.
O segundo desafio foi com a gramática. Tivemos algumas dificuldades em reproduzir a gramática da página 15 do manual de referência do ChocoPy até perceber que precisaríamos criar uns símbolos não terminais para conseguir refazer algumas regras. Arquivo ChocoPy.cup, a partir da linha 232 (block, elif_expression e else_expression, por exemplo).
