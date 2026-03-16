*** Settings ***
Library    RequestsLibrary

*** Variables ***
${BASE_URL}    https://serverest.dev

*** Keywords ***
Conectar na API
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    Create Session    alias=ServeRest    url=${BASE_URL}    headers=${headers}    verify=${True}