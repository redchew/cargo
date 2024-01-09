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

#ifndef BREADBOARD_VERSION_H_
#define BREADBOARD_VERSION_H_

/// @file breadboard/version.h
/// @brief A structure containing the version number of the Breadboard library.

namespace breadboard {

/// @struct BreadboardVersion
///
/// @brief A structure containing the version number of the Breadboard library.
struct BreadboardVersion {
  /// @brief Version number, updated only on major releases.
  unsigned char major;

  /// @brief Version number, updated for point releases.
  unsigned char minor;

  /// @brief Version number, updated for tiny releases, for example, bug fixes.
  unsigned char revision;

  /// @brief Text string holding the name and version of library.
  const char* text;
};

/// @brief Returns the version struct.
///
/// @return The version struct.
const BreadboardVersion& Version();

}  // namespace breadboard

#endif  // BREADBOARD_VERSION_H_
