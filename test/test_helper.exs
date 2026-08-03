ExUnit.start()

ExVCR.Config.cassette_library_dir("test/fixture/vcr_cassettes")
Req.default_options(adapter: ExOura.Test.Support.ReqFinchAdapter)
