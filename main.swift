import Foundation

struct Folder: Codable {
    let folderName: String
}

struct File: Codable {
    let fileName: String
    let `extension`: String
    let dest: String?
    let content: String? // Added content property
}

struct Template: Codable {
    let templateName: String
    let folders: [Folder]?
    let files: [File]
}

struct VerifiedTemplates: Codable {
    let templates: [Template]
}

func createFolders(_ folders: [Folder]?) {
    guard let folders = folders else { return }
    for folder in folders {
        let folderPath = FileManager.default.currentDirectoryPath + "/" + folder.folderName
        do {
            try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
            print("Created folder: \(folderPath)")
        } catch {
            print("Failed to create folder: \(folderPath), error: \(error)")
        }
    }
}

func createFiles(_ files: [File]) {
    for file in files {
        let destination = file.dest ?? "."
        let filePath = FileManager.default.currentDirectoryPath + "/" + destination + "/" + file.fileName + "." + file.extension
        let fileContent = file.content ?? "// This is a generated file. https://github.com/myferr/make-cli/"
        do {
            try fileContent.write(toFile: filePath, atomically: true, encoding: .utf8)
            print("Created file: \(filePath)")
        } catch {
            print("Failed to create file: \(filePath), error: \(error)")
        }
    }
}

func loadTemplate(from jsonFilePath: String) -> Template? {
    let jsonData: Data

    do {
        jsonData = try Data(contentsOf: URL(fileURLWithPath: jsonFilePath))
    } catch {
        print("Failed to read JSON file: \(jsonFilePath), error: \(error)")
        return nil
    }

    do {
        return try JSONDecoder().decode(Template.self, from: jsonData)
    } catch {
        print("Failed to decode JSON: \(error)")
        return nil
    }
}

func loadVerifiedTemplate(named templateName: String) -> Template? {
    let verifiedTemplatesPath = FileManager.default.currentDirectoryPath + "/verifiedTemplates.json"
    let jsonData: Data

    do {
        jsonData = try Data(contentsOf: URL(fileURLWithPath: verifiedTemplatesPath))
    } catch {
        print("Failed to read verified templates file: \(verifiedTemplatesPath), error: \(error)")
        return nil
    }

    do {
        let verifiedTemplates = try JSONDecoder().decode(VerifiedTemplates.self, from: jsonData)
        return verifiedTemplates.templates.first { $0.templateName == templateName }
    } catch {
        print("Failed to decode verified templates JSON: \(error)")
        return nil
    }
}

func main() {
    guard CommandLine.arguments.count > 1 else {
        print("Usage: make-cli <path-to-json> or make-cli --registered <template-name>")
        return
    }

    let argument = CommandLine.arguments[1]
    let template: Template?

    if argument.hasSuffix("--registered") {
        guard CommandLine.arguments.count > 2 else {
            print("Usage: make-cli --registered <template-name>")
            return
        }
        let templateName = CommandLine.arguments[2]
        template = loadVerifiedTemplate(named: templateName)
    } else {
        template = loadTemplate(from: argument)
    }

    guard let validTemplate = template else {
        print("Failed to load template")
        return
    }

    createFolders(validTemplate.folders)
    createFiles(validTemplate.files)
}

main()