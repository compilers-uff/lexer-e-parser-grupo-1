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

## Submission writeup

Team member 1: Lucca Sabbatini

Team member 2: Renato Montini

Team member 3: Sérgio Ricardo

Agradecimentos aos colegas de turma Isadora Verbicário, João Pedro Mateus e João Guilherme por terem tirado uma dúvida em relação a um problema que estávamos tendo.
E ao Github Copilot por ter explicado porque um erro de compilação estava ocorrendo.

Não sabemos ao certo quantas horas foram necessárias para a realização do trabalho. Mas começamos a trabalhar no dia 05/04 e trabalhamos no projeto praticamente todos os dias desde então. Usando uma média de aproximadamente 3h/dia x 14 dias, foram utilizadas no mínimo 42 horas de trabalho.

- Questões:

1. Para a emissão de INDENTS e DEDENTS, utilizamos uma pilha, inicializada em 0 (linha 178), que guarda o nível de identação do código, e funções para contar (linhas 65 - declaração da função, e 188 - chamada da função) e emitir os tokens (linha 191 - compara o nível de identação com o valor na pilha). Nome do arquivo: ChocoPy.jflex

2. A nossa solução busca realizar exatamente o que é descrito na seção 3.1.5 (Identação) ao utilizar uma pilha para poder contar o nível de identação e ao emitir INDENT sempre que a identação é maior que o topo da pilha e emitir DEDENT enquanto o valor do topo for maior que o da identação da linha lida.


3. Tivemos dois outros desafios além da identação. 
O primeiro foi na definição dos símbolos terminais. Inicialmente não percebemos que a ordem da declaração deles era importante e por isso estávamos tendo problemas para compilar o código e sempre recebíamos avisos que alguns símbolos não eram alcançados nunca. Utilizamos o Github Copilot para nos explicar o erro e ele nos informou que a ordem importava, então alteramos a ordem da nossa declaração para que todos os símbolos pudessem ser alcançados. Arquivo ChocoPy.jflex, a partir da linha 210.
O segundo desafio foi com a gramática. Tivemos algumas dificuldades em reproduzir a gramática da página 15 do manual de referência do ChocoPy até perceber que precisaríamos criar uns símbolos não terminais para conseguir refazer algumas regras. Arquivo ChocoPy.cup, a partir da linha 232 (block, elif_expression e else_expression, por exemplo).