# Explosion_feedstock_ABAP4
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

Você precisa adionar 2 campos que utilizaremos de flag na sua listagem dos itens, o "flagimp" e o "flagprc", que farão a verificação para o recalculo.
 com isto, ele valida pela flag em cada item que devera ser removido ou subtraido do existente e gera a lista solicitada.
 
