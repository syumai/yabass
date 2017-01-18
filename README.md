# Yabass
Yabass is **YA**ML **Ba**sed **S**tatic **S**ite Generator.

## Install
1.Clone this repo

`git clone https://github.com/syumai/yabass/`

2.Append `yabass/bin` to your PATH

## Usage
### 1.Create YAML data file

`data/index.yml`
```yml
posts:
  - id: 1
    title: First page
    body: Hello, world
  - id: 2
    title: Second page
    body: Hello, hello, world
```

### 2.Create Views

* Template layout view
* Index view
* Show view (for each 'posts' or something)

```
└── views
    ├── _layout.erb
	└── posts
		├── index.erb
		└── show.erb
```

### 3.Generate static html

Run `yabass generate` or `yabass g` then your static site will be generated in your `public` directory!

```
└── public
   └── posts
       ├── index.html
       ├── 1
       │   └── index.html
       └── 2
           └── index.html
```

## Development

* Run `yabass server` or `yabass s` to run local server. (in `localhost:3030`)

## Routing

### Basic

* Generated html's routing is based on data YAML file.
* `id` attribute is required for each records.
* If you set `key` attribute on your record, it will be used as url.
* When you want to see current routes, run `yabass routes` or `yabass r`.

#### Example

* YAML

`examples/basic/data/index.yml`
```yml
posts:
  - id: 1
    key: hello
    title: First page
  - id: 2
    title: Second page
```

* Views

```
└── views
    ├── _layout.erb
	└── posts
		├── index.erb
		└── show.erb
```

* Routes

```sh
/posts       # Posts index
/posts/hello # First user
/posts/2     # Second user
```

### Nesting

* To nest pages, simply nest your data models and views.

#### Example

* YAML

`examples/nested/data/index.yml`
```yml
users:
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

* Views

```
└── views
    ├── _layout.erb
	└── users
		├── index.erb
		├── show.erb
		└── posts
		    ├── index.erb
		    └── show.erb
```

* Routes

```sh
/users             # Users index
/users/ken         # First user
/users/ken/posts   # Users Posts index
/users/ken/posts/1 # First post
/users/ken/posts/2 # Second post
```

### Hiding keys

* If you don't want to add model names to URL (ex. 'users' or 'posts'), add '\_' on the top of the model name.

#### Example

* YAML

`examples/nested/data/index.yml`
```yml
_users:
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

* Views

```
└── views
    ├── _layout.erb
	└── users
		├── show.erb
		└── posts
		    └── show.erb
```

* Routes

```sh
/ken   # First user
/ken/1 # First post
/ken/2 # Second post 
```


## Author
syumai

## License
MIT

