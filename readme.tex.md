# Optymalizacja siatki czworościennej

Repozytorium powstało na potrzeby pracy magisterskiej w celu gromadzenia wiedzy i śledzenia postępu prac. 

Praca magisterka obejmuje zagadnienia z:

- metody elementów skończonych,
- analizy elektromagnetycznej,
- generowania siatki czworościennej,
- optymalizacji nieliniowej bez ograniczeń,



### Metryka jakości (ang. <i>quality metric</i>)

Do oceny jakości poszczególnych czworościanów została zastosowana metryka oparta na stosunku objętości do długości krawędzi (ang. <i>volume-length</i>):

$6\sqrt{2}\frac{V}{L_{rms}^3}$, gdzie $V$ to objętość czworościanu, $L_{rms}$ to średnia kwadratowa długości krawędzi czworościanu.

Dla regularnych czworościanów metryka przyjmuje wartość 1 (maximum) .



### Różnice skończone (ang. <i>finite difference</i>)

Do aproksymacji gradientu funkcji zostały zastosowane centralne różnice (ang. <i>central difference</i>)

$\frac{\partial f}{\partial x} = \frac{f(x + \Delta x, y, z) - f(x-\Delta x, y, z)}{2 \Delta x}$

$\frac{\partial f}{\partial y} = \frac{f(x, y + \Delta y, z) - f(x, y - \Delta y, z)}{2\Delta y}$

$\frac{\partial f}{\partial z} = \frac{f(x, y, z+\Delta z) - f(x, y, z - \Delta z)}{2\Delta z}$



### Metoda gradientu prostego

Iteracyjna metoda poszukiwania minimum (maksimum) funkcji. W optymalizacji siatki celem jest znalezienie $\underset{x}{\max} f(x)$, gdzie $f(x)$ to minimalna wartość metryki jakości czworościanów w sąsiedztwie analizowanego węzła.. Metoda gradientu prostego jest dana następującym wzorem:

$x_n = x_{n-1} + \eta \nabla f(x)$, gdzie  $\nabla f(x)$ to gradient $f(x)$, $\eta$ to arbitralnie ustalony krok.



### Zadania do wykonania

- [x] implementacja metryki jakości czworościanu $6\sqrt{2}\frac{V}{L_{rms}^3}$
- [x] implementacja gradientu metryki jakości czworościanu
- [x] implementacja różnic skończonych do aproksymacji gradientu i hesjanu metryki jakości
- [x] implementacja metody gradientu prostego
- [x] porównanie metod optymalizacji czworościanu
- [ ] ciąg dalszy nastąpi....

### Zależności

- [immoptibox](http://www2.imm.dtu.dk/projects/immoptibox/): A MATLAB TOOLBOX FOR OPTIMIZATION AND DATA FITTING