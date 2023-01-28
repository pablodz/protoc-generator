# Proto3 code generator from .proto

Proto libraries generators made easy.


## Requirements

- Docker
- Make
  - [ ] Windows (not tested)
  - [x] Linux (/bin/bash)
  - [x] Mac (/bin/bash)
- yq [https://github.com/mikefarah/yq](https://github.com/mikefarah/yq)
- xargs

## Installation

1. Clone this template
2. Place your proto files inside [./protos/v1/](./protos/v1/)
3. Configure setup/generator.yaml (recommended just to change paths if needed, will work with template defaults)
4. Execute one of the following formats
 
```bash
#recommended
make loadenvs
make generate verbose=true
```



## Roadmap

- [x] Google libraries support
- [x] Recursive imports and proto generator
- [x] Precompiled protoc-plugins to easy generate external libraries
- [x] Precompiled docker image
- [ ] Packages
  - [ ] C# / .NET
  - [ ] C++
  - [ ] Dart
  - [x] Go (Golang) (go.mod & go.sum)
  - [ ] Java
  - [ ] Kotlin
  - [x] Node (Javascript)
  - [ ] Objective-C
  - [ ] PHP
  - [x] Python
  - [ ] Ruby
- [ ] Exports support
  - [ ] C# / .NET
  - [ ] C++
  - [ ] Dart
  - [x] Go (Golang)
  - [ ] Java
  - [ ] Kotlin
  - [x] Node (Javascript)
  - [ ] Objective-C
  - [ ] PHP
  - [x] Python
  - [ ] Ruby
- grpc_plugins
  - [x] /grpc_plugins/grpc_cpp_plugin  
  - [x] /grpc_plugins/grpc_csharp_plugin  
  - [x] /grpc_plugins/grpc_node_plugin  
  - [x] /grpc_plugins/grpc_objective_c_plugin  
  - [x] /grpc_plugins/grpc_php_plugin  
  - [x] /grpc_plugins/grpc_python_plugin  
  - [x] /grpc_plugins/grpc_ruby_plugin  
- google/protobuf
  - [x] any.proto
  - [x] api.proto
  - [x] compiler
    - [x] plugin.proto
  - [x] descriptor.proto
  - [x] duration.proto
  - [x] empty.proto
  - [x] field_mask.proto
  - [x] source_context.proto
  - [x] struct.proto
  - [x] timestamp.proto
  - [x] type.proto
  - [x] wrappers.proto


