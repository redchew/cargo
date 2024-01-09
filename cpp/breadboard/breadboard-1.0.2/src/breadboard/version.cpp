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

#include "breadboard/version.h"

namespace breadboard {

#define BREADBOARD_VERSION_MAJOR 1
#define BREADBOARD_VERSION_MINOR 0
#define BREADBOARD_VERSION_REVISION 2

// Turn X into a string literal.
#define BREADBOARD_STRING_EXPAND(X) #X
#define BREADBOARD_STRING(X) BREADBOARD_STRING_EXPAND(X)

/// @var kVersion
/// @brief String which identifies the current version of MathFu.
///
/// @ref kVersion is used by Google developers to identify which applications
/// uploaded to Google Play are using this library. This allows the development
/// team at Google to determine the popularity of the library.
/// How it works: Applications that are uploaded to the Google Play Store are
/// scanned for this version string. We track which applications are using it
/// to measure popularity. You are free to remove it (of course) but we would
/// appreciate if you left it in.
///
static const BreadboardVersion kVersion = {
  BREADBOARD_VERSION_MAJOR,
  BREADBOARD_VERSION_MINOR,
  BREADBOARD_VERSION_REVISION,
  "Breadboard "
  BREADBOARD_STRING(BREADBOARD_VERSION_MAJOR) "."
  BREADBOARD_STRING(BREADBOARD_VERSION_MINOR) "."
  BREADBOARD_STRING(BREADBOARD_VERSION_REVISION)
};

const BreadboardVersion& Version() { return kVersion; }

}  // namespace breadboard
