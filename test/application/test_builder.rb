require 'test/application/helper'

class TestApplicationBuilder < TestApplicationModule

  def hotconsole
    @@hotconsole ||= Builder.new hotconsole_spec
  end
  def stopwatch
    @@stopwatch  ||= Builder.new stopwatch_spec
  end

  def test_caches_spec
    assert_equal stopwatch_spec, stopwatch.spec
  end

  def test_deploy_option_gems
    assert_includes stopwatch.send(:deploy_options),  '--gem rest-client'
    refute_includes hotconsole.send(:deploy_options), '--gem'
  end

  def test_deploy_option_compile
    assert_includes stopwatch.send(:deploy_options),  '--compile'
    refute_includes hotconsole.send(:deploy_options), '--compile'
  end

  def test_deploy_option_embed_bs
    refute_includes stopwatch.send(:deploy_options),  '--bs'
    assert_includes hotconsole.send(:deploy_options), '--bs'
  end

  def test_deploy_option_stdlib
    assert_includes stopwatch.send(:deploy_options),  '--no-stdlib'
    refute_includes hotconsole.send(:deploy_options), 'stdlib'

    spec = minimal_spec do |s|
      s.stdlib = ['matrix', 'base64']
    end
    options = Builder.new(spec).send :deploy_options
    refute_includes options, '--no-stdlib'
    assert_includes options, '--stdlib matrix'
    assert_includes options, '--stdlib base64'
  end

  def test_plist_hash_from_spec_overrides_all
    spec = hotconsole_spec.dup
    spec.plist[:MyKey]            = true
    spec.plist[:NSPrincipleClass] = 'Foo'
    spec.plist[:CFBundleName]     = 'Cake'

    plist = load_plist(Builder.new(spec).send(:info_plist))
    assert_equal true,            plist[:MyKey             ]
    assert_equal 'Foo',           plist[:NSPrincipleClass  ]
    assert_equal 'Cake',          plist[:CFBundleName      ]
    assert_equal spec.identifier, plist[:CFBundleIdentifier]
  end

end
