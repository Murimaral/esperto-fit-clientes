require 'rails_helper'

feature 'Personal login on system' do
  before do
    allow(Subsidiary).to receive(:all)
      .and_return([Subsidiary.new(id: 1, name: 'Vila Maria', address: 'Avenida Osvaldo Reis, 801',
                                  cnpj: '11189348000195', token: 'CK4XEB'),
                   Subsidiary.new(id: 1, name: 'Super Esperto', address: 'Avenida Ipiranga, 150',
                                  cnpj: '11189348000195', token: 'CK4XEB')])
  end

  scenario 'successfully' do
    personal = create(:personal)

    visit root_path
    click_on 'Entrar'
    click_on 'aqui'
    fill_in 'CPF', with: personal.cpf
    fill_in 'Senha', with: personal.password
    click_on 'Log in'

    expect(page).to have_content('Login efetuado com sucesso')
    expect(page).to_not have_link('Entrar')
    expect(page).to_not have_link('Registrar')
    expect(page).to have_link('Sair')
  end

  scenario 'personal failed to login' do
    personal = create(:personal)

    visit root_path
    click_on 'Entrar'
    click_on 'aqui'
    fill_in 'CPF', with: ''
    fill_in 'Senha', with: personal.password
    click_on 'Log in'

    expect(page).to have_content('CPF ou senha inválidos.')
  end

  scenario 'and log out' do
    personal = create(:personal)

    login_as personal, scope: :personal
    visit root_path
    click_on 'Sair'

    expect(page).to have_content('Logout efetuado com sucesso')
  end
end
