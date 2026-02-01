<%@ include file="includes/header.jsp" %>

<style>
    .values-grid {
        display: flex;
        justify-content: center;
        gap: 40px;
        text-align: center;
        margin-top: 30px;
        flex-wrap: wrap;
    }

    .value-card {
        background: #ffffff;
        padding: 25px;
        border-radius: 10px;
        max-width: 280px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    /* Centralized text and added padding */
    .about-section,
    .about-values,
    .about-team {
        text-align: center;
        padding: 60px 20px;
    }

    .about-section .container,
    .about-values .container,
    .about-team .container {
        max-width: 900px;
        margin: 0 auto;
    }

    .about-section h2,
    .about-values h2,
    .about-team h2 {
        margin-bottom: 30px;
        font-size: 2.5em;
    }

    .about-section p,
    .about-team p {
        font-size: 1.1em;
        line-height: 1.8;
        margin: 0 auto;
        max-width: 800px;
    }

    .hero.about-hero {
        padding: 80px 20px;
    }

    .hero-content {
        text-align: center;
    }

    .value-card h3 {
        margin-bottom: 15px;
        font-size: 1.5em;
    }

    .value-card p {
        line-height: 1.6;
    }

    .team-image {
        margin: 30px auto;
        max-width: 600px;
    }

    .team-image img {
        width: 100%;
        height: auto;
        border-radius: 10px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }
</style>

<!-- About Hero Section -->
<section class="hero about-hero">
    <div class="hero-content">
        <div class="hero-text">
            <h1>About Us</h1>
            <p>Dedicated to providing compassionate and professional elderly care services in Singapore</p>
        </div>
        <div class="hero-image">
            <img src="images/about-elderly-care.jpg" alt="About our elderly care service">
        </div>
    </div>
</section>

<!-- Mission Section -->
<section class="about-section">
    <div class="container">
        <h2>Our Mission</h2>
        <p>
            Our mission is to enhance the quality of life of seniors by offering reliable and
            personalized care services. We aim to support families by ensuring their loved ones
            receive the attention, companionship, and medical support they need.
        </p>
    </div>
</section>

<!-- Values Section -->
<section class="about-values">
    <div class="container">
        <h2>Our Values</h2>
        <div class="values-grid">
            <div class="value-card">
                <h3>Compassion</h3>
                <p>We treat every senior with respect, kindness, and empathy.</p>
            </div>

            <div class="value-card">
                <h3>Professionalism</h3>
                <p>Our caregivers are trained, certified, and passionate about their work.</p>
            </div>

            <div class="value-card">
                <h3>Trust</h3>
                <p>We build long-term relationships through transparent and reliable service.</p>
            </div>
        </div>
    </div>
</section>

<!-- Team Section -->
<section class="about-team">
    <div class="container">
        <h2>Meet Our Team</h2>
        <div class="team-image">
            <img src="images/avatar-maker-online-free-featured-image.jpg" alt="Our care team">
        </div>
        <p>
            Our team is made up of experienced caregivers, nurses, and administrators dedicated
            to ensuring high-quality elderly care. We work together to create a safe, supportive,
            and nurturing environment for all seniors under our care.
        </p>
    </div>
</section>

<%@ include file="includes/footer.jsp" %>