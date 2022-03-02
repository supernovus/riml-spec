# RIML

## Version

1.12

### Updated

2022-03-02

### [Changelog]

## Summary

The Routing Information Modeling Language is a compact YAML-based dialect for defining routing information and API documentation.

Kind of inspired by RAML and a few other similar descriptive schemas, but was
designed with some specific hybrid use-cases in mind (specifically one schema
that could be used to define routes in a web app, generate API documentation, 
and generate automated tests.)

## Implementations

| Language | Package | Description |
| -------- | ------- | ----------- |
| PHP | [riml/riml-parser](https://packagist.org/packages/riml/riml-parser) | A pure parser library. See [lum/lum-core](https://packagist.org/packages/lum/lum-core) for an example of a package that uses RIML to build routing configuration files. |
| Node.js | [riml](https://www.npmjs.com/package/riml) | A pure-JS parser library. |

## Development Notes

The RIML specification, and indeed the two reference implementations are still in development, and not everything is finalized.
Things in here may change before the final `1.0` specification is published, so if you are using RIML already, be aware of that.

## Version Notes

DRAFT-11 changes how the `!include` and `!includePath` statements determine if the filename is relative to the configuration directory or not. 

Also a few minor cleanups and clarifications.

## Property Definitions

### Global Properties

Global keywords can appear anywhere in a RIML document, and the closest defined item will be used if it's not found in a Route.

| Keyword | Description | Valid values |
| ------- | ----------- | ------------ |
| `version` | The API version. | `number`, `string` |
| `title` | A short name for documentation. | `string` |
| `description` | A full description for documentation. | `string` |
| `controller` | The backend controller that handles this route. | `string` |
| `method` | The controller method that handles this route. | `string` |
| `apiType` | The API type used. Set to `false` for none, or `true` for auto. | `false`, `"json"`, `"xml"`, `true` |
| `authType` | The Auth system used. Set to `false` for none, or `true` for any. | `false`,`true`,`string`,`array` |

The `authType` in addition to the pre-defined boolean values, may also be a string or array of strings referring to which plugin(s) which may be supported by the specific implementation in use. We don't define any predetermined types in the specification.

### Route Properties

These keywords must be found inside a Route definition itself.

The `path` is usually defined as a property name itself, rather than explicitly setting a `path` property.

| Keyword | Description | Valid values |
| ------- | ----------- | ------------ |
| `name` | The name used by the Router class to refer to this route. | `string` |
| `path` | The path we are matching against, with any placeholders. | `string` |
| `http` | The HTTP Method(s) used by this route. | `array,string`: `"GET"`, `"PUT"`, `"POST"`, `"DELETE"`, `"PATCH"`, `"HEAD"` |
| `virtual` | This is not a real Route, but child Routes inherit it's properties. | `false`, `true` |
| `noPath` | Only useful on `virtual` Routes, this Route does not set a path. | `false`, `true` |
| `contentType` | The content-type. If excluded defaults will be used based on `apiType`. | `string`, see [Content Type](#content-type) |
| `requestSchema` | A reference to a JSON Schema or XML Schema that the PUT, POST, or PATCH data must validate against. | `string` |
| `responseSchema` | A reference to a JSON Schema or XML Schema that the returned data must validate against. | `string` |
| `pathParams` | A list of supported path parameters (marked by placeholders.) | See [Parameters](#parameters) |
| `queryParams` | A list of supported query parameters. | See [Parameters](#parameters) |
| `headers` | A list of supported headers. | See [Parameters](#parameters) |
| `responseCodes` | A list of possible HTTP response codes. | See [Response Codes](#response-codes) |
| `examples` | A list of examples for documentation. | See [Examples](#examples) |
| `tests` | A set of parameters for automated tests. | See [Tests](#tests) |
| `defaultRoute` | This route is the default if no others match. Only one Route should ever be default. | `false`, `true` |
| `redirect` | A URL (or _route name_) this Route redirects to. | `string` |
| `redirectRoute` | The `redirect` is the name of a _Route_, not a URL. | `false`, `true` |

Note: while most keywords apply traits to the current Route and any child routes, `virtual` and `noPath` only applies to the current Route itself. Those particular keywords are not passed along in the dependency tree.

### Content Type

If it is not specified, the `contentType` assumes the following defaults based on the `apiType`:

| apiType | contentType |
| ------- | ----------- |
| `null` | `"text/html"` |
| `"json"` | `"application/json"` |
| `"xml"` | `"application/xml"` |
| `"text"` | `"text/plain"` |

### Response Codes

Each property is an HTTP Response code that may be returned (just the number, i.e. `200`), and should contain the following properties:

| Keyword | Description | Valid values |
| ------- | ----------- | ------------ |
| `description` | The full description of the HTTP code for documentation. | `string` |
| `success` | The method call was a success if this code is returned. | `false`, `true` |
| `bodySchema` | A reference to a JSON Schema or XML Schema that the body must validate against if this code is returned. | `string` |

The `bodySchema` is an optional feature that if used will override the `responseSchema` and allows for different schemata for different response codes.

### Parameters

Each property in `pathParams`, `queryParams`, or `headers` is the name of a the parameter.
The value must be an object, and supports the following properties:

| Keyword | Description | Valid values |
| ------- | ----------- | ------------ |
| `title` | A short name of the parameter for documentation. | `string` |
| `description` | A full description of the parameter for documentation. | `string` |
| `type` | A simple hint of what kind of value is supported. | `string`: `"string"`, `"number"`, `"integer"` |
| `required` | Is this query parameter mandatory? | `false`, `true` |
| `multiple` | Can this parameter be included more than once? | `false`, `true` |

When defining an example or test using multiple parameters, just use an array value.

The `multiple` option does not work on `pathParams`.

### Examples

The `examples` property is an array of objects, where each object supports the following properties:

| Keyword | Description | Valid values |
| ------- | ----------- | ------------ |
| `title` | A short name of the example. | `string` |
| `description` | A full description of the example. | `string` |
| `request` | An object describing the request for this example. | See [Request Properties](#request-properties) |
| `response` | An object describing the response from the example. | See [Response Properties](#response-properties) |

### Tests

The `tests` property is an array of objects. The `Test` objects are an extension of the `Example` objects.
They contain all of the same properties as the above `Example Properties` documentation, plus the following additional properties:

| Keyword | Description | Valid values |
| ------- | ----------- | ------------ |
| `validateRequest` | Should the request body be validated before submitting? | `false`, `true` |
| `validateResponse` | Should the response be validated after returning? | `true`, `false`, `array`: `"body"`, `"code"`, `"type"` |
| `authOptions` | Options specific to the `authType` being used. | `object` |

If `validateResponse` is an array, it lists the parts of the response which must be validated.

The `response` property is treated differently in a `Test` as it would be in an `Example`. 
If it is specified, it represents the expected response from the test service call.

### Request Properties

| Keyword | Description | Valid values |
| ------- | ----------- | ------------ |
| `http` | For Routes that support multiple `http` methods, force the use of this one in the example. | `string` |
| `body` | A reference to a JSON or XML file containing an example PUT, POST, or PATCH body. | `string` |
| `queryParams` | An object where each key is the name of a query parameter, and each value is the parameter value. | `object` |
| `pathParams` | An object where each key is the name of a path parameter, and each value is the parameter value. | `object` |
| `headers` | An object where each key is the name of a header, and each value is the header value. | `object` |
| `authType` | If multiple `authType` plugins are supported, this forces the use of a specific one for a test. | `string` |
| `apiType` | If multiple `apiType` formats are supported, this forces the use of a specific one for a test. | `string` |

### Response Properties

| Keyword | Description | Valid values |
| ------- | ----------- | ------------ |
| `code` | The HTTP status code that should be received for this response. | `number` |
| `body` | A reference to a JSON or XML file containing the response body. | `string` |
| `type` | The content-type returned in this response (will use defaults based on `apiType` or `contentType`.) | `string` |
| `class` | A custom plugin for validation (only useful in `tests`) | `string` |

## Route Definitions

The property name should be either the `path` (in which case you don't have to set a path inside the definition), or a placeholder value.
If the method is a simple word with no slashes, the path will be assumed to have no URL parameters.

If the property has the `!controller` trait, or a property called `.controller` set to `true`, the name of the property is the name of the controller.
If the property has the `!method` trait, or a property called `.method` set to `true`, the method name will be set to `handle_property_name` where `property_name` is the name of the property. These are convenient short cuts.

The `!virtual` trait can be used instead of setting a `virtual: true` property.

Nested Routes prepend their parent Route's path to their own.

### HTTP Method Child Routes

Within a Route (typically one marked as `virtual`) any property with the name of an HTTP Method (see `http` keyword values above) will be considered a child route specific to that method. This is an easy way to have a single path with multiple actions depending on the HTTP Method used.

### API Type Child Routes

If a child route has the name `"json"` or `"xml"` with no other characters, it will set `apiType` to it's own value, and assume the parent path.

## Options

Any property starting with a dot will be considered an Option. Options can be used for implementation-specific purposes.

The only global (document level) option that should be supported by all implementations is `.includePoly` which if `true` means the file can be included more than once.

## Include statements

A property in a file can include another file by using a YAML processing statement:

```yaml
#%RIML 1.0
title: An example file
common_routes: !include common_routes.yaml
```

If the filename does not start with a slash, the filename will be considered to be relative to the directory of the calling file. It is valid to use filenames
like `subdirectory/something.yaml` or `../includes/common_file.yaml` just
remembering that subsequent include statements in those files will be relative
as well.

If the top-level definition in the included file does not include a `virtual` property, it will be set to `true` when included.
If the top-level definition in the included file does not include a `noPath` property, it will be set to `true` when included.
This is because generally the top level definition in a file is a group of routes, not a route in and of itself.

If the included document does not have a `.includePoly` property set to `true` it can only be included once in a complete RIML data structure.

Note: While YAML supports multiple streams in a single document, the RIML specification does not. How to treat multiple streams is not defined in the specification.

## Include Path statements

The `!includePath` statement works exactly the same as `!include` except that it will not set the `noPath` property to `true`.

## Traits and Trait Placeholder Values

If you have a lot of routes that use a very similar structure with just a few differences, traits are handy helpers.

Traits can be included in any section of data, and will add their own properties into that section as long as the property does not exist.
This means the order you add traits in is important, as later traits will not be able to override properties from earlier ones.

Traits may contain placeholder values, which if used, will be replaced with real values when the trait is used in a section.

### !define

The `!define` statement defines either a trait, and any placeholder values it supports.

The properties used to define traits will not be included in the final routing structure (they are metadata only, like Options.)

#### Defining a Trait

When defining a trait, it requires the `.trait` property, which is the name of the trait.

```yaml
my_trait: !define
  .trait: my_trait
  http:
    - GET
    - POST
  apiType: json
  responseSchema: src/schemata/api/json/standard_response.json
```

#### Trait Placeholders

If your trait contains placeholder values, then you must define a property named `.placeholders` which contains a list of placeholder variables and the paths they are found in the trait.

The path delimiter is the pipe | character. This was chosen because / and . are both often used in the actual property names (something not common in programming languages, but essential in a routing information map.)

The paths may be deeply nested, and the last item in the path name may refer to placeholder strings in the template properties, or a property name itself.

```yaml
my_var_trait: !define
  .trait: my_var_trait
  .placeholders:
    section:
      - path|:section
      - method|<section>
      - .reference|test|name 
  path: /appname/:section/document.json
  method: handle_<section>_document
  .reference:
    test:
      name: ~
```

### !use

The `!use` statement applies previously defined traits.

You must have a `.traits` property that lists any traits you want to include.
If placeholder values are used by any of the traits, you must also include a `.vars` property, which will contain the values to use for each placeholder.

Traits themselves may contain a `.vars` property which will be handled differently than regular trait properties, in that the contents of it will be merged with the existing `.vars` property, again only adding ones not already defined. This can be used to create traits that define common values for placeholders in other traits.

```yaml
another_section: !use
  .traits:
    - my_trait
    - my_var_trait
  .vars:
    section: hello_world
  controller: my_controller
```

### Example Trait Compilation

The `!define` and `!use` examples above combined would generate the following structure when compiled:

```yaml
a_section:
  controller: my_controller
  http:
    - GET
    - POST
  apiType: json
  responseSchema: src/schemata/api/json/standard_response.json  
  path: /appname/hello_world/document.json
  method: handle_hello_world_document
  .reference:
    test:
      name: hello_world
```

Note that `.reference` is an option, and therefore wouldn't be included in the final routing structure.

## Example RIML Definition

Here is an example showing off some of the features currently defined. Note we are currently using the `:placeholder` style that the Nano.php Router plugin uses rather than the `{placeholder}` style, which may or may not be supported depending on the implementation.

```yaml
#%RIML 1.0
title: Foobar
description: Routing for the Foobar controller
controller: foobar
"/:pid/foobar/":
  description: View the current Foobar document in the browser
  apiType: false
  authType: userOnly
  method: handle_default
  upload_logo: !method
    description: Upload a logo file asynchronously
  import:
    description: Use the Import Foobar service
    controller: foobar.import
    name: foobar.import
    method: handle_default
    new: !method
      description: Create a new Foobar request
    "/:rid":
      description: View a Foobar report.
      method: handle_view_report
      POKE:
        description: Set the report as the current Foobar document.
        method: handle_set_report
      DELETE:
        apiType: json
        description: Delete a Foobar report.
        method: handle_delete_report
"/:pid/foobar.json": !virtual
  apiType: json
  authType: true
  GET:
    description: Get the contents of the Foobar document.
    method: handle_get_doc
    returnSchema: src/schemata/api/json/foobar_get.json
  PUT:
    description: Replace the document.
    method: handle_put_doc
    bodySchema: src/schemata/models/foobar.json
    returnSchema: src/schemata/api/json/foobar_put.json
    tests:
      - body: src/schemata/api/examples/json/foobar_put.json
  PATCH:
    description: Update the document using a patch.
    method: handle_patch_doc
    returnSchema: src/schemata/api/json/foobar_patch.json
    tests: 
      - body: src/schemata/api/examples/json/foobar_patch.json
```

NOTE: Some YAML parsers do not like property names with colons and/or slashes in them, so for the sake of the example, they are surrounded with "quotes".
The riml.js and Nano.php parsers have no problems without the quotes. Your milage may vary.

The above example would generate the following Path/HTTP method combinations.

| Route Name | URL Path | HTTP Method | Controller | Controller Method |
| ---------- | -------- | ----------- | ---------- | ----------------- |
| `foobar` | `/:pid/foobar/` | `GET`, `POST` | `foobar` | `handle_default` |
| `foobar_upload_logo` | `/:pid/foobar/upload_logo` | `GET`, `POST` | `foobar` | `handle_upload_logo` |
| `foobar.import` | `/:pid/foobar/import` | `GET`, `POST` | `foobar.import` | `handle_default` |
| `foobar.import_new` | `/:pid/foobar/import/new` | `GET`, `POST` | `foobar.import` | `handle_new` |
| `foobar.import_view_report` | `/:pid/foobar/import/:rid` | `GET`, `POST` | `foobar.import` | `handle_view_report` |
| `foobar.import_set_report` | `/:pid/foobar/import/:rid` | `POKE` | `foobar.import` | `handle_set_report` |
| `foobar.import_delete_report` | `/:pid/foobar/import/:rid` | `DELETE` | `foobar.import` | `handle_delete_report` |
| `foobar_get_docs` | `/:pid/foobar.json` | `GET` | `foobar` | `handle_get_doc` |
| `foobar_put_doc` | `/:pid/foobar.json` | `PUT` | `foobar` | `handle_put_doc` |
| `foobar_patch_doc` | `/:pid/foobar.json` | `PATCH` | `foobar` | `handle_patch_doc` |


[Changelog]: https://github.com/supernovus/riml-spec/blob/main/CHANGELOG.md

