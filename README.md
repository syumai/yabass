# Yabass
Yabass is **YA**ML **Ba**sed **S**tatic **S**ite Generator.

## Install
1. Clone this repo

`git clone https://github.com/syumai/yabass/`

2. Append `yabass/bin` to your PATH

## Usage
### 1.Create YAML data file

`data/index.yml`
```yml
pages:
  - posts:
      - id: 1
        title: First page
        body: Hello, world
      - id: 2
        title: Second page
        body: Hello, hello, world
```

### 2.Create Views

* Layout file
* Index view
* Show view (for each 'posts' or something)

are available.

```
└── views
    ├── _layout.erb
	└── posts
		├── index.erb
		└── show.erb
```

### 3.Generate static html

Run `yabass generate` and your static site will be generated in your `public` directory!

## Routing

### Basic

* Generated html's routing is based on data YAML file.
* `id` attribute is required for each records.
* If you set `key` attribute on your record, it will be used as url.

## YAML Format

#### Example

* YAML

`examples/basic/data/index.yml`
```yml
pages:
  - posts:
      - id: 1
        key: hello
        title: First page
      - id: 2
        title: Second page
```

* route

```sh
/public/posts       # Posts index
/public/posts/hello # First user
/public/posts/2     # Second user
```

### Nesting

TODO:

#### Example

* YAML

`examples/nested/data/index.yml`
```yml
pages:
  - users:
      - id: 1
        key: ken
        name: First user
        posts:
          - id: 1
            title: First post
            body: Hello, world
          - id: 2
            title: Second post
            body: Hello, hello, world
```

* route

```sh
/public/users               # Users index
/public/users/1             # First user
/public/users/1/posts       # Users Posts index
/public/users/1/posts/hello # First post
/public/users/1/posts/2     # Second post
```

### Hiding keys

TODO:

#### Example

* YAML

`examples/nested/data/index.yml`
```yml
pages:
  - _users:
      - id: 1
        key: ken
        name: First user
        _posts:
          - id: 1
            title: First post
            body: Hello, world
          - id: 2
            title: Second post
            body: Hello, hello, world
```

* route

```sh
/public/1       # First user
/public/1/hello # First post
/public/1/2     # Second post 
```


## Author
syumai

## License
MIT

