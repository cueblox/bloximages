# BloxImages 

A [blox](https://github.com/cueblox/blox) prebuild plugin to create image records for the images in your static directory.

`bloximages` scans your `static_dir` for images, then creates a yaml file for each image in your `data_dir` in the format `image_id.yaml`. In a prebuild step, it reads each image from disk and records the dimensions in the yaml file.

Because it is a `prebuild` plugin, cue records are created for each image, allowing you to use the image in relational records.

Example article:

```yaml
title: My Article
image_id: athens
```

This would reference an image in the `static_dir` file name (without extension) of `athens`.

The `athens.yml` file that is created by this plugin might look like this:

```yaml
file_name: images/athens.jpg
height: 364
width: 795
cdn: "https://images.brian.dev/images/"
```

It stores the file name relative to the `static_dir` and the dimensions of the image. 

Optionally you can export an environment variable named `CDN_URL` to store a CDN prefix for the image. When used in combination with the [staticsync](https://github.com/cueblox/staticsync) plugin, the CDN prefix will allow you to construct the full URL to the image on your CDN. The CDN prefix should be specified to include the base CDN and the bucket where you're storing images.

```
cdn: "https://images.brian.dev/images/"
               ^^^ CDN BASE     ^^^ BUCKET
```

## Getting Started

BloxImages is written in Go. You'll need a local Go installation to use it, so follow the [instructions](https://go.dev/learn/) at [go.dev](https://go.dev/) to install Go on your computer.


### Prerequisites

The things you need before installing the software.

* Go version 1.17 or later.


### Installation

```
$ go get github.com/cueblox/bloximages
```

## Usage

Add the plugin to your `blox.cue` configuration file as a prebuild plugin.


```
{
  data_dir: "data"
  schemata_dir: "data/schemata"
  build_dir: ".build"
  template_dir: "data/tpl"
  static_dir: "public/static"
  prebuild: [ {
    name: "bloximages"
    executable: "bloximages"
  }]
}
```

## Configuration

Add an `image` (named `image.cue`) schema to your `blox` schemata directory:

```
{
	_schema: {
		name:      "Image"
		namespace: "schemas.cueblox.com"
	}

	#Image: {
		_dataset: {
			plural: "images"
			supportedExtensions: ["yaml", "yml"]
		}

		file_name:          string
		width:              int
		height:             int
    cdn?:               string
		alt_text?:          string
		caption?:           string
		attribution?:       string
		attribution_link?:  string
	}
}

```

## Contributing

See [contributing guide](CONTRIBUTING.md) for more information.

## Future Features

BloxImage may be updated to automatically generate resized and optimized images at a variety of breakpoints.

Inspiration: [11ty Image](https://www.11ty.dev/docs/plugins/image/) is an 11ty image plugin that generates responsive images.