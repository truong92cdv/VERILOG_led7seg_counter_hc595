... developmenting ... not yet done ...

[Vietnamese version here!](./README_VI.md)

# Led7seg Counter with HC595 

Thiết kế bộ đếm 4 led 7 đoạn (0-9999). Giao tiếp Verilog qua ic thanh ghi dịch HC595.

## I. Tác giả

- **Name:** Võ Nhật Trường
- **Email:** truong92cdv@gmail.com
- **GitHub:** [truong92cdv](https://github.com/truong92cdv)

## II. Kết quả demo

https://github.com/user-attachments/assets/e14f3003-0783-4027-b96c-c62e5e2e1b5a

## III. Thiết bị

- ZUBoard 1CG mã XCZU1CG-1SBVA484E.
- Led7seg 4 số có tích hợp 4 ic HC595.
- 3 đường dây tín hiệu SRCLK, RCLK và SER; dây VCC +5V; dây GND.

Trên thị trường có 4 loại module led7seg 4 số thông dụng, tương ứng mỗi loại thì giao tiếp với Verilog cũng khác nhau:
1. Led 7 đoạn đơn thuần (common cathode hoặc common anode). Cần đến 12 chân giao tiếp.
   
![4led7seg_no_ic](./images/4led7seg_no_ic.jpg)

2. Led 7 đoạn tích hợp ic TM1637. Dùng 2 chân giao tiếp CLK và DIO
   
![4led7seg_tm1637](./images/4led7seg_tm1637.jpg)

3. Led 7 đoạn tích hợp 2 ic HC595. 1 ic điều khiển các đoạn led A->DP, 1 ic để chọn led. Dùng 3 chân giao tiếp SRCLK, RCLK, SER.
   
![4led7seg_2hc595](./images/4led7seg_2hc595.jpg)

4. Led 7 đoạn tích hợp 4 ic HC595. Mỗi ic điều khiển 1 led riêng biệt. Dùng 3 chân giao tiếp SRCLK, RCLK, SER.
   
![4led7seg_4hc595](./images/4led7seg_4hc595.jpg)

Trong bài này tôi dùng loại thứ 4.


## IV. HC595

HC595 là 1 ic thanh ghi dịch 8 bit. Đọc thêm về hc595 tại đây [HC595](https://dientutuonglai.com/tim-hieu-74hc595.html)

Dữ liệu được gửi đến hc595 theo từng bit tại mỗi cạnh lên xung clk. Khi đã gửi đủ 8 bit, kéo chân RCLK (hoặc ST_CP) lên mức cao để chốt dữ liệu đến đầu ra Q0 -> Q7 (hoặc QA -> QH).

Một ưu điểm của hc595 là nó có thể xếp tầng để điều khiển hơn 8 đầu ra, bằng cách kết nối chân Q7' (hoặc QH') của ic phía trước với chân SER của ic phía sau.

Sơ đồ cấu tạo của HC595 như sau:

![schematic_hc595](./images/schematic_hc595.webp)

Module 4 led 7 đoạn của chúng ta gồm 4 ic hc595 xếp tầng theo sơ đồ sau:

![schematic_4hc595_daisy_chained](./images/schematic_4hc595_daisy_chained.jpg)

Như vậy để điều khiển 4 led, ta cần gửi cả 32 bit dữ liệu rồi mới kéo chân RCLK lên mức cao để chốt dữ liệu.

## V. Thiết kế các khối chức năng

Chương trình gồm 4 khối chức năng chính:
1. Khối **clk_divider**: chia clk 100 MHz của ZUBoard thành clk 10 Hz (100 ms).
2. Khối **digits**: nhận clk đầu vào 10 MHz, đầu ra là 4 chữ số **dig_0**, **dig_1**, **dig_2**, **dig_3** dưới dạng số thập phân. Các số này đếm từ 0 -> 9999, tăng lên mỗi 100 ms.
3. Khối **bcd_to_led7seg**: gồm 4 bản sao. Mỗi khối nhận đầu vào là 1 chữ số từ khối **digits**, chuyển nó sang dạng mã hóa led 7 đoạn.
4. Khối **gen_eninput_pulse**: tạo xung **en_input** kích hoạt khối **hc595_driver** hoạt động.
5. Khối **hc595_driver**: nhận đầu vào là 32 bit dữ liệu mã hóa 4 chữ số dạng led 7 đoạn. Tạo các tín hiệu giao tiếp với module 4 hc595 xếp tầng điều khiển 4 led 7 đoạn.

![schematic_top](./images/shcematic_top.png)


