npm install --save @petfinder/petfinder-js

<script src="https://unpkg.com/axios/dist/axios.min.js"></script>
<script src="https://unpkg.com/@petfinder/petfinder-js/dist/petfinder.min.js"></script>

var pf = new petfinder.Client({apiKey: "cl001uOF6pmYwCW4zCKsenpJjVoIl1NdgJ5mRJ90dynC8IyaVg", secret: "I3Z5E6IKTTCOd87obf3gIBF1nhRgPoW4r0JRIsI4"});

pf.animal.search()
    .then(function (response) {
        // Do something with `response.data.animals`
    })
    .catch(function (error) {
        // Handle the error
    });