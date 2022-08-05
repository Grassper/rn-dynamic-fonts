/**
 * Copyright (c) 2017-present, grassper. All rights reserved.
 *
 * This source code is licensed under the MIT license found in the LICENSE file in the root
 * directory of this source tree.
 */

const { NativeModules } = require('react-native');
const { DynamicFonts } = NativeModules;
const loadedFonts = {};

function loadFont(name, data, type, forceLoad) {
  /* Check if this font was already loaded */
  if (!forceLoad && loadedFonts[name])
    return Promise.resolve(loadedFonts[name]);

  if (!name)
    throw new Error('Name is a required argument');

  if (!data)
    throw new Error('Data is a required argument');

  /* Load font via native binary code */
  return new Promise(function(resolve, reject) {
    DynamicFonts.loadFont({
      name: name,
      data: data,
      type: type
    }, function(err, givenName) {
      if (err) {
        reject(err);
        return;
      }

      /* Loaded successfully... resolve promise with "real" font name */
      loadedFonts[name] = givenName;
      resolve(givenName);
    });
  });
}

function loadFontFromFile(name, filePath) {
  if (!name)
    throw new Error('name is a required argument');

  if (!filePath)
    throw new Error('filePath is a required argument');

  return new Promise(function(resolve, reject) {
    DynamicFonts.loadFontFromFile({
      name,
      filePath
    }, function(err, givenName) {
      if (err) {
        reject(err);
        return;
      }
      resolve(givenName);
    });
  });
}

function unsupportedFeature () {
  return Promise.reject("The feature is unsupported on this platform")
}

function loadFonts(_fontList, forceLoad) {
  var fontList = _fontList;
  if (!fontList)
    return Promise.resolve([]);

  if (!(fontList instanceof Array))
    fontList = [fontList];

  return Promise.all(fontList.filter((font) => font).map((font) => loadFont(font.name, font.data, font.type, forceLoad)));
}

module.exports = {
	loadFont: loadFont,
  loadFonts: loadFonts,
  loadFontFromFile: loadFontFromFile
}
