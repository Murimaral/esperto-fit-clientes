require 'rails_helper'

feature 'client edit profile' do
  xscenario 'from edit_profile_path' do
    client = create(:client)

    login_as client, scope: :client
    visit edit_profile_path

    expect(current_path).to eq root_path
  end

  scenario 'and sucessfully' do
    client = create(:client)
    payment_option = create(:payment_option)
    subsidiary = Subsidiary.new(id: 1, name: 'Vila Maria',
                                address: 'Avenida Osvaldo Reis, 801', cep: '88306-773')
    plan = Plan.new(id: 1, name: 'Black', monthly_payment: 120.00, permanency: 12,
                    subsidiary: subsidiary)
    enroll = Enroll.create!(client: client, plan_id: plan.id,
                            payment_option: payment_option,
                            subsidiary_id: subsidiary.id)
    create(:profile, enroll: enroll)

    login_as client, scope: :client
    visit root_path
    click_on 'Meu perfil'
    click_on 'Editar perfil'
    fill_in 'Nome', with: 'Jonas'
    fill_in 'Endereço', with: 'Rua Vila Velha, 101'
    click_on 'Salvar alterações'

    expect(page).to have_content(profile.name)
    expect(page).to have_content(profile.address)
    expect(page).to have_link('Voltar', href: root_path)
  end

  scenario 'and attributes cannot be blank' do
    client = create(:client)
    payment_option = create(:payment_option)
    subsidiary = Subsidiary.new(id: 1, name: 'Vila Maria',
                                address: 'Avenida Osvaldo Reis, 801', cep: '88306-773')
    plan = Plan.new(id: 1, name: 'Black', monthly_payment: 120.00, permanency: 12,
                    subsidiary: subsidiary)
    enroll = Enroll.create!(client: client, plan_id: plan.id,
                            payment_option: payment_option,
                            subsidiary_id: subsidiary.id)
    create(:profile, enroll: enroll)

    login_as client, scope: :client
    visit root_path
    click_on 'Meu perfil'
    click_on 'Editar perfil'
    click_on 'Salvar alterações'

    expect(page).to have_content('não pode ficar em branco', count: 2)
    expect(page).to have_link('Voltar', href: profile_path(profile))
  end
end