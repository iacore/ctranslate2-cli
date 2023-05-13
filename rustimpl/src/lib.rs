use std::path::{Path, PathBuf};

use pyo3::types::IntoPyDict;
use pyo3::{prelude::*, prepare_freethreaded_python};
use sentencepiece::SentencePieceProcessor;

pub struct Translator {
    model: Py<PyAny>,
    tokenizer: SentencePieceProcessor,
}

impl Translator {
    pub fn init(base_path: &Path) -> eyre::Result<Self> {
        Python::with_gil(|py| {
            let ctranslate2 = py.import("ctranslate2")?;
            let tokenizer = SentencePieceProcessor::open(base_path.join("sentencepiece.model"))?;

            Ok(Self {
                model: ctranslate2
                    .getattr("Translator")?
                    .call1((base_path.join("model"),))?
                    .to_object(py),
                tokenizer,
            })
        })
    }

    pub fn translate(&self, s: &str) -> eyre::Result<String> {
        let tokens: Vec<String> = self
            .tokenizer
            .encode(s)?
            .into_iter()
            .map(|x| x.piece)
            .collect();
        Python::with_gil(|py| {
            let a = self
                .model
                .getattr(py, "translate_batch")?
                .call1(([tokens],))?.;
            Ok(())
        })?;
    }
}

#[test]
fn test_init() {
    let _tr = Translator::init(&default().join("en_de")).unwrap();
}

pub fn default() -> PathBuf {
    PathBuf::from(format!(
        "{}/.local/share/argos-translate/packages",
        std::env::var("HOME").expect("$HOME should be set")
    ))
}
