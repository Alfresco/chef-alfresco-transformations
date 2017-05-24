describe TransformationHelper do
  let(:dummy_transformationhelper) { Class.new { include TransformationHelper } }

  describe '#rpm_version' do
    let(:shellout) { double('shellout') }

    before do
      allow(shellout).to receive_messages(
        :run_command => nil,
        :error! => nil,
        :live_stream => nil,
        :live_stream= => nil
      )
      @rpm_name = 'libreoffice'
    end

    context 'when calling rpm_name with a long version' do
      it 'returns the first 3 digits' do
        allow(Mixlib::ShellOut).to receive(:new).with("rpm -qa --queryformat \"%{VERSION}\" #{@rpm_name}", anything).and_return(shellout)
        allow(shellout).to receive(:stdout).and_return('3.4.5.6.2')

        transformationhelper = dummy_transformationhelper.new
        res = transformationhelper.rpm_version(@rpm_name)
        expect(res).to eq('3.4.5')
      end
    end

    context 'when calling rpm_name with a short version' do
      it 'returns the version itself' do
        allow(Mixlib::ShellOut).to receive(:new).with("rpm -qa --queryformat \"%{VERSION}\" #{@rpm_name}", anything).and_return(shellout)
        allow(shellout).to receive(:stdout).and_return('3.4')
        transformationhelper = dummy_transformationhelper.new
        res = transformationhelper.rpm_version(@rpm_name)
        expect(res).to eq('3.4')
      end
    end
  end

  describe '#libre_office_path' do
    let(:shellout) { double('shellout') }
    before do
      allow(shellout).to receive_messages(
        :run_command => nil,
        :error! => nil,
        :live_stream => nil,
        :live_stream= => nil
      )
    end

    context 'when calling libre_office_path' do
      it 'returns the libreoffice path' do
        allow(Mixlib::ShellOut).to receive(:new).with('whereis -b libreoffice | xargs readlink -z', anything).and_return(shellout)
        allow(shellout).to receive(:stdout).and_return('/opt/libreoffice5.2/program/soffice')
        transformationhelper = dummy_transformationhelper.new
        res = transformationhelper.libre_office_path
        expect(res).to eq('/opt/libreoffice5.2')
      end

      it 'raise an exception if libreoffice is not installed' do
        allow(Mixlib::ShellOut).to receive(:new).with('whereis -b libreoffice | xargs readlink -z', anything).and_return(shellout)
        allow(shellout).to receive(:stdout).and_return('')
        transformationhelper = dummy_transformationhelper.new
        expect { transformationhelper.libre_office_path }.to raise_error('Libreoffice Not Installed')
      end
    end
  end

  describe '#folders_name' do
    let(:shellout) { double('shellout') }
    before do
      allow(shellout).to receive_messages(
        :run_command => nil,
        :error! => nil,
        :live_stream => nil,
        :live_stream= => nil
      )
      @path = '/usr/lib64/ImageMagick-7.0.5/'
    end

    context 'when calling folders_name with config' do
      it 'returns the config folder name' do
        allow(Mixlib::ShellOut).to receive(:new).with("find #{@path} -maxdepth 1 -type d -iname 'config*'", anything).and_return(shellout)
        allow(shellout).to receive(:stdout).and_return('config-Q16HDRI')
        transformationhelper = dummy_transformationhelper.new
        res = transformationhelper.folders_name(@path, 'config')
        expect(res).to eq('config-Q16HDRI')
      end
    end

    context 'when calling folders_name with config' do
      it 'returns the modules folder name' do
        allow(Mixlib::ShellOut).to receive(:new).with("find #{@path} -maxdepth 1 -type d -iname 'modules*'", anything).and_return(shellout)
        allow(shellout).to receive(:stdout).and_return('modules-Q16HDRI')
        transformationhelper = dummy_transformationhelper.new
        res = transformationhelper.folders_name(@path, 'modules')
        expect(res).to eq('modules-Q16HDRI')
      end
    end
  end
end
