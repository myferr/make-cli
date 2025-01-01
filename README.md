# make-cli

`make-cli` is a Swift command-line tool that helps you create folders and files based on a JSON template. This tool is useful for setting up project structures quickly and consistently.

You can download the latest version of `make-cli` from the [Releases](https://github.com/myferr/make-cli/releases) tab on the GitHub repository. Follow these steps:

1. Install and check if you have Git.
2. Execute the following command: `git clone https://github.com/myferr/make-cli/`
4. Move the `make-cli` executable and repository files to a directory that is in your system's PATH.

Move the executable and repository files to `/usr/local/bin`:

```sh
sudo mv make-cli /usr/local/bin/
```
> `make-cli` as in the folder that git has initialized, not the executable.

## Features

- Create folders and files from a JSON template.
- Supports nested folder creation.
- Allows specifying file content.
- Load templates from a file or from a list of verified templates.

## Usage

### Create from JSON file

To create folders and files from a JSON file, run:

```sh
make-cli <path-to-json>
```

### Create from registered template

To create folders and files from a registered template, run:

```sh
make-cli --registered <template-name>
```

## JSON Template Structure

The JSON template should have the following structure:

```json
{
  "templateName": "exampleTemplate",
  "folders": [
    {
      "folderName": "src"
    },
    {
      "folderName": "tests"
    }
  ],
  "files": [
    {
      "fileName": "main",
      "extension": "swift",
      "dest": "src",
      "content": "print(\"Hello, world!\")"
    },
    {
      "fileName": "README",
      "extension": "md",
      "content": "# Project Title"
    }
  ]
}
```

- `templateName`: The name of the template.
- `folders`: An array of folders to create.
  - `folderName`: The name of the folder.
- `files`: An array of files to create.
  - `fileName`: The name of the file.
  - `extension`: The file extension.
  - `dest`: The destination folder (optional).
  - `content`: The content of the file (optional).

## Example

Here is an example of how to use `make-cli`:

1.  Create a JSON file `template.json` with the following content:

        ```json
        {
            "templateName": "myTemplate",
            "folders": [
                {
                    "folderName": "src"
                }
            ],
            "files": [
                {
                    "fileName": "main",
                    "extension": "swift",
                    "dest": "src",
                    "content": "print(\"Hello, world!\")"
                }
            ]
        }
        ```

2.  Run the command:

        ```sh
        make-cli template.json
        ```

This will create a `src` folder and a `main.swift` file inside it with the specified content.

## License

This project is licensed under the MIT License.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## Register a theme

Open a pull request and commit your theme to `verifiedTemplates.json`
