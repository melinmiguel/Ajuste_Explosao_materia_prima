# Ajuste_Explosao_materia_prima
Módulo para validar se a matéria prima de um item foi detalhada corretamente subtraída a existente. (precisa de uma tabela inicial)

Fiz este programa pois notei que muitos programadores ABAP vinham tendo problemas com a validação dos itens nos diversos estoques possveis
Ele faz validação, de default, nos estoques:
  - Normal;
  - Qualidade;
  - Transferência;
  - Chão de Fábrica;
  - Consignado;
  - Beneficiario.
  Com isto, altere conforme o necessário e ajuste as variáveis locais.
  
  com isto, ele revalida e adiciona um token em cada item que devera ser removido ou subtraido do existente.
 
