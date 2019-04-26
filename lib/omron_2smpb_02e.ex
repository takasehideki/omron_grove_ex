defmodule GrovePi.Omron2smpb02e do
  @moduledoc """
  OMRON 2smpb_02e

  Example usage:
  ```
  TODO
  ```
  """

  require Logger

  alias GrovePi.{Board, I2C, Omron2smpb02e}
  import Bitwise

  @i2c_addr 0x56

  @reg_temp_txd0       0xfc
  @reg_temp_txd1       0xfb
  @reg_temp_txd2       0xfa
  @reg_press_txd0      0xf9
  @reg_press_txd1      0xf8
  @reg_press_txd2      0xf7
  @reg_io_setup        0xf5
  @reg_ctrl_meas       0xf4
  @reg_device_stat     0xd3
  @reg_i2c_set         0xf2
  @reg_iir_cnt         0xf1
  @reg_reset           0xe0
  @reg_chip_id         0xd1
  @reg_coe_b00_a0_ex   0xb8
  @reg_coe_a2_0        0xb7
  @reg_coe_a2_1        0xb6
  @reg_coe_a1_0        0xb5
  @reg_coe_a1_1        0xb4
  @reg_coe_a0_0        0xb3
  @reg_coe_a0_1        0xb2
  @reg_coe_bp3_0       0xb1
  @reg_coe_bp3_1       0xb0
  @reg_coe_b21_0       0xaf
  @reg_coe_b21_1       0xae
  @reg_coe_b12_0       0xad
  @reg_coe_b12_1       0xac
  @reg_coe_bp2_0       0xab
  @reg_coe_bp2_1       0xaa
  @reg_coe_b11_0       0xa9
  @reg_coe_b11_1       0xa8
  @reg_coe_bp1_0       0xa7
  @reg_coe_bp1_1       0xa6
  @reg_coe_bt2_0       0xa5
  @reg_coe_bt2_1       0xa4
  @reg_coe_bt1_0       0xa3
  @reg_coe_bt1_1       0xa2
  @reg_coe_b00_0       0xa1
  @reg_coe_b00_1       0xa0

  @avg_skip    0x0
  @avg_1       0x1
  @avg_2       0x2
  @avg_4       0x3
  @avg_8       0x4
  @avg_16      0x5
  @avg_32      0x6
  @avg_64      0x7

  @mode_sleep  0x0
  @mode_forced 0x1
  @mode_normal 0x3

  @doc """
  TODO
    def __init__(self,address=0x56):
        self.I2C_ADDR = address
        self.writeByteData(0xf5, 0x00)
        time.sleep(0.5)
        self.setAverage(self.AVG_1,self.AVG_1)
  """
  def initialize() do
    #{:ok, pid} = I2C.start_link("i2c-1", @i2c_addr)
    {:ok, pid} = ElixirALE.I2C.start_link("i2c-1", @i2c_addr)

    writeByteData(0xf5, 0x00)
    Process.sleep(500)
    setAverage(@avg_1, @avg_1)

    {:ok, pid}
  end
  
  @doc """
  TODO
    def writeByteData(self,address,data):
        bus.write_byte_data(self.I2C_ADDR, address, data)
  """
  def writeByteData(address,data) do
    Board.i2c_write_device(@i2c_addr, <<address, data>>)
  end  

  @doc """
  TODO
    def readByte(self,addr):
        data = bus.read_i2c_block_data(self.I2C_ADDR, addr, 1)
        return data[0]
  """
  def readByte(pid, addr) do
    data = I2C.read(pid, addr)
  end


  @doc """
  TODO
    def setAverage(self,avg_tem,avg_pressure):
        bus.write_byte_data(self.I2C_ADDR, self.REG_CTRL_MEAS, 0x27)
  """
  def setAverage(avg_tem,avg_pressure) do
    Board.i2c_write_device(@i2c_addr, <<@reg_ctrl_meas, 0x27>>)
  end

  @doc """
  TODO
    def readRawTemp(self):
        temp_txd2 = self.readByte(self.REG_TEMP_TXD2)
        temp_txd1 = self.readByte(self.REG_TEMP_TXD1)
        temp_txd0 = self.readByte(self.REG_TEMP_TXD0)
        Dt = (temp_txd2 << 16 | temp_txd1 << 8 | temp_txd0) - pow(2,23)
        return Dt
  """
  def readRawTemp(pid) do
    """
    temp_txd2 = readByte(pid, @reg_temp_txd2)
    temp_txd1 = readByte(pid, @reg_temp_txd1)
    temp_txd0 = readByte(pid, @reg_temp_txd0)
    """
    rawData = ElixirALE.I2C.read(pid, 75)
    <<_::8*72, temp_txd0::integer, temp_txd1::integer, temp_txd0::integer = rawData
    dt = bor(temp_txd2<<<16,(bor(temp_txd1<<<8,temp_txd0))) - pow(2,23)

    Logger.info temp_txd2 <> " " <> temp_txd1 <> "" <> temp_txd0 <> "" <> dt

    dt
  end

  @doc """
  TODO
  https://awochna.com/2017/04/02/elixir-math.html
  """
  def pow(base, 1), do: base
  def pow(base, exp), do: base * pow(base, exp - 1)

end
