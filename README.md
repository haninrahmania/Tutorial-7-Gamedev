**Nama: Hanin Atina Rahmania**
**NPM: 2106751234**
**Tutorial 7 Game Development**

**Implementasi Sprint dan Crouch Player**
>>Pertama saya tambahkan variabel walk_speed, sprint_speed, dan crouch_speed pada script player, kemudian memeriksa input pemain menggunakan Input.is_action_pressed(), dan mengatur kecepatan karakter sesuai tombol yang ditekan (shift untuk crouch dan ctrl untuk sprint, kedua actions ini saya set sebagai crouch dan sprint di project settings). Terakhir, saya mengimplementasikan kecepatan ke velocity di _physics_process().

**Implementasi Item Pick up and Inventory Player**
>>Untuk inventory, saya buat inventory sebagai array di script player, lalu untuk pickup item, saya menggunakan RayCast3D dari kamera untuk mendeteksi objek di depan pemain. Kemudian saya menambahkan metode interact() di objek yang dapat diambil. Jika objek yang di interact oleh player menggunakan tombol E memiliki metode interact(), metode tersebut dipanggil untuk memindahkan item ke inventory player.

**Implementasi Lamp yang bisa dinyala/matikan**
>>Saya menggunakan cara yang sama seperti penggunaan raycast3d untuk item pickup untuk player berinteraksi dengan lamp, namun pada lamp saya set omnilight is_on atau !is_on
