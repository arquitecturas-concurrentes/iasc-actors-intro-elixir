Actors
======

## Como instalar elixir?

Ver [aqui](https://elixir-lang.org/install.html) como instalar elixir en su sistema operativo

## Como cargo todo el codigo en el interprete???

```elixir
> iex -S mix
```

- Para cerrar: Apretar dos veces ``` ctrl + c ```


### Sobre los procesos

**Spawn** es la primitiva para crear un proceso, que se le puede pasar una función que sea un loop que se llame a sí mismo y de acuerdo al mensaje que reciba realizará una acción. Esta es la manera más simple de que un actor quede vivo después de procesar los mensajes que tiene en el mailbox. De otra manera una vez que un actor que se crea mediante spawn termina de procesar la funcion que se le pasa, termina muriendo.

Dentro del loop se usa el metodo **receive/1**  que nos permite que se pueda buscar el mensaje a partir de su estructura, mediante pattern matching. **receive/1** soporta guardas y varias clausulas como **case/2**, entre otras. Recordar de que es un metodo bloqueante por lo que el actor se bloqueara hasta cuando no reciba un mensaje en el mailbox.



