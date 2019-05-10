

   function escolha_curtoValueChanged(app, event)
            value = app.escolha_curto.Value
          
                if value == 1
                app.resposta.Value=1;
                elseif value == 2
                app.resposta.Value=2;
                else 
                app.resposta.Value=3;
                end