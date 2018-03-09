module ArcusErrors
  class Base < RuntimeError; end
  class InvalidParameter < Base; end
  class InvalidFunction < Base; end
  class UnknownDeviceAuthType < Base; end
  class UnknownVariableSourceType < Base; end
  class DataSourceError < Base; end
  class HostNotFound < Base; end
  class TransformationError < Base; end
  class MissingRootError < Base; end
  class MissingDataError < Base; end
  class MissingLabelError < Base; end
  class NullLabelsError < Base; end
  class NullValuesError < Base; end

  class DeviceTypeMismatch < Base
    def initialize(msg = 'Device type does not match template type.')
      super
    end
  end
end
