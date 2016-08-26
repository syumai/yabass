# Yabass
Yabass is **YA**ML **Ba**sed **S**tatic **S**ite Generator.

## Install
1. Clone this repo
`git clone https://github.com/syumai/yabass/`

2. Append yabass/bin to your PATH

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

## Author
syumai

## License
MIT
