// Copyright 2015 Google Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#ifndef BREADBOARD_MODULES_DEBUG_H_
#define BREADBOARD_MODULES_DEBUG_H_

#include "breadboard/module_registry.h"

/// @file breadboard/modules/debug.h
///
/// @brief Initialize the debug modules.

namespace breadboard {

/// @brief Initialize the debug module.
///
/// @param[in,out] module_registry The ModuleRegistry that will hold the module
/// registered by this function.
void InitializeDebugModule(ModuleRegistry* module_registry);

}  // namespace breadboard

#endif  // BREADBOARD_MODULES_DEBUG_H_
