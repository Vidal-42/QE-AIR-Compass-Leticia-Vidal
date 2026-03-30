Strictly keep the folders /support/data, /support/common, /support/variables, /keywords, and /tests. Do not create new folders (such as 'utils' or 'helpers').

Imports: All resources should preferably be imported via @base.robot or using relative paths (e.g., ../common/common.robot).

Data Factory: New test data should only be created within data_factory.robot using FakerLibrary.

Style: Use the "Title Case" naming convention for Keywords and "UPPER_CASE" for global variables. Add [Documentation] to complex keywords.