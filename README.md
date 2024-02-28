<h1>ADDI AI Coding </h1>
<hr/>
Block coding application utilizing ADDI blocks
<br/><br/>
<h1> 📱 Project Introduction </h1>
<hr/>
Connect Addi blocks via Bluetooth. <br/>
Then, perform block coding and execute it to see the ADDI blocks operate in real-time.
<br/><br/>
<h1>:calendar: When? </h1>
<hr/>
240201~ , KIST_Creamo
<br/><br/>
<h1>🙂 Members </h1>
<hr/>

|Members|
|------|
|[Seungyeon JI](https://github.com/jisally)|
|[Heeyun HEO](https://github.com/Heeyun0724)|
|[Jiwoo BYUN](https://github.com/dede0827)|

<h1>:gear: Environment Setting</h1>
<hr/>

[![예제](http://img.youtube.com/vi/usE9IKaogDU/0.jpg)](https://youtu.be/usE9IKaogDU?t=0s)

<ul>
  <li><b>IDE: Android Studio 2022.3.1.21</b></li>
  <li><b>Flutter SDK: 3.16.8</b></li>
</ul>
<br/><br/>
<h1>▶ How to RUN? </h1>
<hr/>

    flutter run lib/main.dart


<br/>
<h1>🏆 Results </h1>
<hr/>

<h2> MAIN PAGE</h2>

![1](https://github.com/multi-sensor/CREAMO_Team_A/assets/83489449/d09c1b2c-32e4-495d-96c2-a585e66614e2)
<br/>
<h2> START PAGE </h2>

![2](https://github.com/multi-sensor/CREAMO_Team_A/assets/90318181/e7abe5fd-a531-423b-9b7d-d7d2cf21bd78)
<br/>
<h2>PUZZLE PAGE</h2>

![3](https://github.com/multi-sensor/CREAMO_Team_A/assets/90318181/a033b2ec-726b-4f74-8a86-be7c1fac25b4)

TBD

<br/>
<h1> 📑Flow Chart </h1>
<hr/>

![002](https://github.com/multi-sensor/CREAMO_Team_A/assets/90318181/62794b7c-946d-42a5-ab11-7297e9e62515)


<br/><br/>
<h1> ➕ Details </h1>
<hr/>

`main.dart`

* The file that runs the application.


`splash_page.dart`

* This is the initial screen where Addi AI coding is executed.


`start_page.dart`

* The page is for choosing between "Getting Started" and "How to Use."


`content_page.dart`

* You can check the quiz table of contents and select a quiz from here.


`puzzle_page.dart`
1. App Bar
- The app bar contains navigation and control buttons. It includes a logo, a home button, a Bluetooth button, and a power-off button.


2. Image Navigation
- Users can navigate through different sections of the puzzle image using buttons located at the top of the screen. Each button corresponds to a specific section of the puzzle.


3. Puzzle Grid
- The main section of the page displays the puzzle grid where users can drag and drop puzzle pieces. The puzzle grid is horizontally scrollable, allowing users to access different parts of the puzzle.


4. Draggable Puzzle Pieces
- Puzzle pieces are represented as draggable images. Users can long-press and drag these pieces across the puzzle grid. When dropped, the pieces snap into place based on predefined snap points, ensuring they align correctly with adjacent pieces.


5. Trash Can
- There's a trash can icon located at the bottom right corner of the screen. Users can drag unwanted puzzle pieces to the trash can to delete them from the grid.


6. Reset Button
- A reset button is available at the bottom left corner of the screen. Users can tap this button to reset the puzzle grid, clearing all placed pieces.


7. Play Button
- The play button at the bottom left corner initiates a process to identify and send data related to the connected puzzle pieces. It identifies the sequence of connected pieces and sends the data, possibly for further processing or action.


8. Bluetooth Integration
- The widget includes functionality to interact with Bluetooth devices. This functionality might involve scanning for nearby Bluetooth devices or sending data over a Bluetooth connection.


9. Status Bar Management
- The widget manages the visibility of the status bar, possibly hiding it to provide a full-screen puzzle experience.


10. Supporting Classes
- The widget utilizes supporting classes such as DraggableImage to represent individual puzzle pieces and manage their behavior.


`bluetooth_helper.dart`

1. Start Bluetooth Scan:
- Clears the list of discovered devices.
- Displays information about the connected device if one is already connected.
- Requests location permission if it's not granted.
- Initiates the initial scan and displays discovered devices if permission is granted.

2. Initial Scan and Device Display:
- Displays a dialog box indicating the progress of the Bluetooth scan.
- Initiates the scan and filters the results for devices with names containing 'Creamo_CB_'.
- Stops the scan after 3 seconds and displays a list of discovered devices.

3. Show Connected Device:
- Displays information about the connected device in a dialog box.
- Provides options to disconnect or close the dialog.

4. Show Devices Dialog:
- Displays a dialog box listing discoverable Bluetooth devices.
- Allows the user to tap on a device to attempt a connection.
- Shows success or failure messages for the connection attempt.

5. Disconnect Device:
- Disconnects the connected Bluetooth device.
- Displays success or failure messages based on the disconnection result.

6. Send Data:
- Transmits data to the connected Bluetooth device.
- Discovers available services and characteristics on the device and writes data to writable characteristics.
