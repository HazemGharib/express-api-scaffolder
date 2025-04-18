# express-api-scaffolder

## How to run the script:

In bash, shell, terminal or powershell run the following command and include your project name in the command.

```sh
sh ./scaffold.sh <project-name>
```

example:

```sh
sh ./scaffold.sh my-app-api
```

## Create new routers:

Make sure that you are inside the project root and run the `create-router.sh` script relative to your current location and include a singular router name.

```sh
sh ../path/to/script/create-router.sh <singular-router-name>
```

example:

```sh
sh ../utils/create-router.sh user
```

## API Collections:

You can import API collections and add to it in the collections folder after scaffolding your project, ideally these collections work properly with ThunderClient extension for VS code.
To complete importing the collection, go to collections tab, find the 3 lines button next to the filter input, click it and choose import then select the json file inside the collections directory.