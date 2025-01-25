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
1. Led 7 đoạn đơn thuần (common cathode hoặc common anode).
![4led7seg_no_ic](./images/4led7seg_no_ic.jpg)

2. Led 7 đoạn tích hợp ic TM1637.
![4led7seg_tm1637](./images/4led7seg_tm1637.jpg)

3. Led 7 đoạn tích hợp 2 ic HC595.
![4led7seg_2hc595](./images/4led7seg_2hc595.jpg)

4. Led 7 đoạn tích hợp 4 ic HC595.
![4led7seg_4hc595](./images/4led7seg_4hc595.jpg)

Trong bài này tôi dùng loại thứ 4.


## IV. Thanh ghi dịch HC595
Trên
