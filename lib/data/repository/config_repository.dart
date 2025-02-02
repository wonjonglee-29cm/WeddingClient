import 'package:wedding/data/raw/deploy_config_raw.dart';
import 'package:wedding/data/remote/static-api.dart';

class ConfigRepository {
  ConfigRepository();

  Future<DeployConfigRaw> getDeployConfig() async {
    final response = await StaticApi.getConfig();
    return DeployConfigRaw.fromJson(response.data);
  }
}
