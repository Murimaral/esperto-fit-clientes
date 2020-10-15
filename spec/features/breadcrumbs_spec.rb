require 'rails_helper'

feature 'Breadcrumbs' do
  context 'subsidiaries and enroll' do
    scenario 'show' do
      visit root_path
      click_on 'Vila Maria'

      expect(page).to have_link('Home', href: root_path)
      expect(page).to have_content('Home Vila Maria')
      expect(page).to_not have_content('Home Matrícula')
    end

    scenario 'search' do
      visit root_path
      click_on 'Buscar'

      expect(page).to have_link('Home', href: root_path)
      expect(page).to have_content('Home Busca')
      expect(page).to_not have_content('Home Vila Maria')
    end

    scenario 'enroll' do
      client = create(:client)

      login_as(client, scope: :client)
      visit root_path
      click_on 'Vila Maria'
      click_on 'Matricule-se'

      expect(page).to have_link('Home', href: root_path)
      expect(page).to have_link('Vila Maria')
      expect(page).to have_content('Home Vila Maria Matrícula')
      expect(page).to_not have_content('Home Busca')
    end

    scenario 'confirm enroll' do
      client = create(:client)
      create(:payment_option)
      subsidiary = Subsidiary.new(id: 1, name: 'Vila Maria',
                                  address: 'Avenida Osvaldo Reis, 801', cep: '88306-773')
      allow(Subsidiary).to receive(:all).and_return([subsidiary])

      login_as(client, scope: :client)
      visit root_path
      click_on 'Vila Maria'
      click_on 'Matricule-se'
      select 'Esperto', from: 'Plano'
      select 'Boleto', from: 'Forma de pagamento'
      click_on 'Próximo'

      expect(page).to have_link('Home', href: root_path)
      expect(page).to have_link('Vila Maria', href: subsidiary_path(subsidiary.id))
      expect(page).to have_link('Matrícula', href: new_subsidiary_enroll_path(subsidiary.id))
      expect(page).to have_content('Home Vila Maria Matrícula Confirmar')
      expect(page).to_not have_content('Home Busca')
    end
  end
end