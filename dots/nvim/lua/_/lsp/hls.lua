return {
  settings = {
    haskell = {
      formattingProvider = "fourmolu",
      formatOnImportOn = true,
      completionSnippetOn = true,
      hlintOn = true,
      checkProject = false,
      maxCompletions = 10,
    },
  },
  force_setup = true,
}

-- {
--     "haskell": {
--         "checkParents": "CheckOnSave",
--         "checkProject": true,
--         "formattingProvider": "ormolu",
--         "maxCompletions": 40,
--         "plugin": {
--             "alternateNumberFormat": {
--                 "globalOn": true
--             },
--             "cabal": {
--                 "globalOn": true
--             },
--             "callHierarchy": {
--                 "globalOn": true
--             },
--             "changeTypeSignature": {
--                 "globalOn": true
--             },
--             "class": {
--                 "codeActionsOn": true,
--                 "codeLensOn": true
--             },
--             "explicit-fields": {
--                 "globalOn": true
--             },
--             "explicit-fixity": {
--                 "globalOn": true
--             },
--             "fourmolu": {
--                 "config": {
--                     "external": false
--                 }
--             },
--             "gadt": {
--                 "globalOn": true
--             },
--             "ghcide-code-actions-bindings": {
--                 "globalOn": true
--             },
--             "ghcide-code-actions-fill-holes": {
--                 "globalOn": true
--             },
--             "ghcide-code-actions-imports-exports": {
--                 "globalOn": true
--             },
--             "ghcide-code-actions-type-signatures": {
--                 "globalOn": true
--             },
--             "ghcide-completions": {
--                 "config": {
--                     "autoExtendOn": true,
--                     "snippetsOn": true
--                 },
--                 "globalOn": true
--             },
--             "ghcide-hover-and-symbols": {
--                 "hoverOn": true,
--                 "symbolsOn": true
--             },
--             "ghcide-type-lenses": {
--                 "config": {
--                     "mode": "always"
--                 },
--                 "globalOn": true
--             },
--             "hlint": {
--                 "codeActionsOn": true,
--                 "config": {
--                     "flags": []
--                 },
--                 "diagnosticsOn": true
--             },
--             "importLens": {
--                 "codeActionsOn": true,
--                 "codeLensOn": true
--             },
--             "moduleName": {
--                 "globalOn": true
--             },
--             "pragmas": {
--                 "codeActionsOn": true,
--                 "completionOn": true
--             },
--             "qualifyImportedNames": {
--                 "globalOn": true
--             },
--             "refineImports": {
--                 "codeActionsOn": true,
--                 "codeLensOn": true
--             },
--             "retrie": {
--                 "globalOn": true
--             },
--             "splice": {
--                 "globalOn": true
--             }
--         }
--     }
-- }
