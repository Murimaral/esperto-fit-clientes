require 'rails_helper'

describe 'Ban user' do
  context 'GET /api/user/:user_cpf/ban' do
    context 'with valid parameters' do
      it 'return 200 status if user have client account' do
        create(:client, cpf: '478.145.318-02')

        post '/api/user/47814531802/ban'

        expect(response).to be_ok
        expect(response.body).to include('Cliente banido com sucesso')
        expect(response.body).to_not include('Personal Trainer banido com sucesso')
      end

      it 'return 200 status if user have personal account' do
        create(:personal, cpf: '478.145.318-02')

        post '/api/user/47814531802/ban'

        expect(response).to be_ok
        expect(response.body).to include('Personal Trainer banido com sucesso')
        expect(response.body).to_not include('Cliente banido com sucesso')
      end

      it 'return 200 if client already banned' do
        allow_any_instance_of(Client).to receive(:cpf_banned?).and_return(true)
        create(:client, cpf: '478.145.318-02')

        post '/api/user/47814531802/ban'

        expect(response).to be_ok
        expect(response.body).to include('Cliente já banido anteriormente')
        expect(response.body).to_not include('Personal Trainer já banido anteriormente')
      end

      it 'return 200 if personal already banned' do
        allow_any_instance_of(Personal).to receive(:cpf_banned?).and_return(true)
        create(:personal, cpf: '478.145.318-02')

        post '/api/user/47814531802/ban'

        expect(response).to be_ok
        expect(response.body).to include('Personal Trainer já banido anteriormente')
        expect(response.body).to_not include('Cliente já banido anteriormente')
      end

      it 'return 200 status if user have client and personal account banned' do
        create(:client, cpf: '478.145.318-02')
        create(:personal, cpf: '478.145.318-02')

        post '/api/user/47814531802/ban'

        expect(response).to be_ok
        expect(response.body).to include('Cliente banido com sucesso')
        expect(response.body).to include('Personal Trainer banido com sucesso')
      end

      it 'return 200 status if user have client and personal account already banned' do
        allow_any_instance_of(Personal).to receive(:cpf_banned?).and_return(true)
        allow_any_instance_of(Client).to receive(:cpf_banned?).and_return(true)
        create(:client, cpf: '478.145.318-02')
        create(:personal, cpf: '478.145.318-02')

        post '/api/user/47814531802/ban'

        expect(response).to be_ok
        expect(response.body).to include('Cliente já banido anteriormente')
        expect(response.body).to include('Personal Trainer já banido anteriormente')
      end

      it 'return 404 if user dont have account' do
        post '/api/user/08858754948/ban'

        expect(response).to be_not_found
        expect(response.body).to include('O usuário não possui cadastro ativo')
      end
    end

    it 'with invalid cpf' do
      post '/api/user/123/ban'

      expect(response).to be_precondition_failed
      expect(response.body).to include('CPF inválido')
    end
  end
end
