initialise_libreoffice 'initialise' do
  only_if { node['transformations']['libreoffice']['initialise']['enabled'] }
  not_if {  shell_out('pgrep -f soffice.bin').exitstatus == 0 }
  only_if { shell_out('whereis -b libreoffice | cut -d\':\' -f2 | grep libreoffice').exitstatus == 0 }
end
