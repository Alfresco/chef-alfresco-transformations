initialise_libreoffice 'initialise' do
  only_if { node['transformations']['libreoffice']['initialise']['enabled'] }
end
