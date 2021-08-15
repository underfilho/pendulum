# Simulação de Pêndulos Simples

[Download](https://github.com/underfilho/pendulum_mobile/raw/main/app-release.apk)

Uma simulação do [Pêndulo Simples](https://en.wikipedia.org/wiki/Pendulum_(mathematics)) criada em Flutter, nele o usuário pode clicar e arrastar para criar pêndulos, além de ver informações sobre cada pêndulo. 

Focando na parte técnica e matemática, criei com a constante gravitacional e massa como 1, e equação de movimento então ficou a=-1*sin(φ)/l (onde a é aceleração, φ o angulo e l a distancia ao centro), foi utilizada integração de euler, mas no futuro pretendo utilizar uma integração numérica mais adequada, foi utilizada a mesma ideia de animação feita minha biblioteca [Workspace](https://github.com/underfilho/Workspace) em que atualizo a tela a cada x milissegundos, através disso posso atualizar valores das variáveis e mostrar novos frames.

<img src="https://user-images.githubusercontent.com/31104317/129486996-2da71924-b35f-471d-9078-1b36873129bd.gif" width="35%" height="35%"/>

Utilizando a mesma ideia é possível simular diversas situações físicas em 2D, apenas com suas equações de movimento e atualizando os valores de variáveis a cada frame.
